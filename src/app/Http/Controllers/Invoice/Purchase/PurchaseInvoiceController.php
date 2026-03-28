<?php

namespace App\Http\Controllers\Invoice\Purchase;

use App\Exceptions\GeneralException;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Purchase\PurchaseInvoiceRequest;
use App\Http\Requests\Invoice\Purchase\PurchasePaymentRequest;
use App\Models\Invoice\Purchase\PurchaseInvoice;
use App\Models\Invoice\Purchase\PurchaseInvoicePayment;
use App\Services\Invoice\Purchase\PurchaseInvoiceStockService;
use Illuminate\Support\Facades\DB;

class PurchaseInvoiceController extends Controller
{
    public function __construct(private readonly PurchaseInvoiceStockService $stockService)
    {
    }

    public function index()
    {
        return PurchaseInvoice::query()
            ->with(['supplier:id,name'])
            ->withCount('items')
            ->when(request('supplier_id'), fn($q) => $q->where('supplier_id', request('supplier_id')))
            ->orderBy('id', request()->get('orderBy', 'desc'))
            ->paginate(request()->get('per_page', 10));
    }

    public function store(PurchaseInvoiceRequest $request)
    {
        try {
            DB::beginTransaction();
            $validated = $request->validated();

            $subTotal = collect($validated['items'])->sum(fn($item) => (float)$item['quantity'] * (float)$item['unit_price']);
            $discount = (float)($validated['discount'] ?? 0);
            $tax = (float)($validated['tax'] ?? 0);
            $total = round($subTotal - $discount + $tax, 2);
            $paid = min((float)($validated['paid_amount'] ?? 0), $total);

            $invoice = PurchaseInvoice::query()->create([
                'supplier_id' => $validated['supplier_id'],
                'invoice_number' => $validated['invoice_number'],
                'invoice_date' => $validated['invoice_date'],
                'sub_total' => $subTotal,
                'discount' => $discount,
                'tax' => $tax,
                'total' => $total,
                'paid_amount' => $paid,
                'note' => $validated['note'] ?? null,
            ]);

            foreach ($validated['items'] as $item) {
                $lineTotal = round((float)$item['quantity'] * (float)$item['unit_price'], 2);
                $invoice->items()->create([
                    'product_id' => $item['product_id'],
                    'quantity' => $item['quantity'],
                    'unit_price' => $item['unit_price'],
                    'line_total' => $lineTotal,
                ]);
            }

            if ($paid > 0) {
                PurchaseInvoicePayment::query()->create([
                    'purchase_invoice_id' => $invoice->id,
                    'amount' => $paid,
                    'payment_date' => $validated['invoice_date'],
                    'reference' => __('default.opening_balance'),
                ]);
            }

            $this->stockService->apply($invoice);
            DB::commit();
            return created_responses('purchase_invoice');
        } catch (\Throwable $e) {
            DB::rollBack();
            throw new GeneralException($e->getMessage());
        }
    }

    public function show(PurchaseInvoice $purchaseInvoice): PurchaseInvoice
    {
        return $purchaseInvoice->load(['supplier', 'items.product:id,name,code,current_quantity,last_purchase_price', 'payments']);
    }

    public function update(PurchaseInvoiceRequest $request, PurchaseInvoice $purchaseInvoice)
    {
        try {
            DB::beginTransaction();
            $this->stockService->rollback($purchaseInvoice);
            $purchaseInvoice->items()->delete();

            $validated = $request->validated();
            $subTotal = collect($validated['items'])->sum(fn($item) => (float)$item['quantity'] * (float)$item['unit_price']);
            $discount = (float)($validated['discount'] ?? 0);
            $tax = (float)($validated['tax'] ?? 0);
            $total = round($subTotal - $discount + $tax, 2);
            $existingPayments = (float)$purchaseInvoice->payments()->sum('amount');
            $paid = min(max($existingPayments, (float)($validated['paid_amount'] ?? 0)), $total);

            $purchaseInvoice->update([
                'supplier_id' => $validated['supplier_id'],
                'invoice_number' => $validated['invoice_number'],
                'invoice_date' => $validated['invoice_date'],
                'sub_total' => $subTotal,
                'discount' => $discount,
                'tax' => $tax,
                'total' => $total,
                'paid_amount' => $paid,
                'note' => $validated['note'] ?? null,
            ]);

            foreach ($validated['items'] as $item) {
                $purchaseInvoice->items()->create([
                    'product_id' => $item['product_id'],
                    'quantity' => $item['quantity'],
                    'unit_price' => $item['unit_price'],
                    'line_total' => round((float)$item['quantity'] * (float)$item['unit_price'], 2),
                ]);
            }

            $this->stockService->apply($purchaseInvoice);
            DB::commit();
            return updated_responses('purchase_invoice');
        } catch (\Throwable $e) {
            DB::rollBack();
            throw new GeneralException($e->getMessage());
        }
    }

    public function destroy(PurchaseInvoice $purchaseInvoice)
    {
        DB::transaction(function () use ($purchaseInvoice) {
            $this->stockService->rollback($purchaseInvoice);
            $purchaseInvoice->delete();
        });

        return deleted_responses('purchase_invoice');
    }

    public function addPayment(PurchasePaymentRequest $request, PurchaseInvoice $purchaseInvoice)
    {
        $amount = (float)$request->input('amount');
        if ($amount > $purchaseInvoice->due_amount) {
            throw new GeneralException(__('default.amount_should_be_less_or_equal_to_due'));
        }

        $purchaseInvoice->payments()->create($request->validated());
        $purchaseInvoice->update(['paid_amount' => round($purchaseInvoice->paid_amount + $amount, 2)]);

        return response()->json(['message' => __('default.payment_has_been_done_successfully')]);
    }
}
