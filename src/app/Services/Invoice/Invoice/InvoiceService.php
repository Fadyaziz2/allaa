<?php

namespace App\Services\Invoice\Invoice;

use App\Jobs\Invoice\Invoice\InvoiceAttachmentJob;
use App\Mail\Invoice\Invoice\InvoiceRecurringMail;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\Invoice\InvoiceDetail;
use App\Models\Invoice\Product\Product;
use App\Models\Invoice\Transaction\Transaction;
use App\Repositories\Core\StatusRepository;
use App\Services\Invoice\AppService;
use App\Services\Invoice\Customization\CustomizationService;
use App\Services\Invoice\Product\ProductStockService;
use App\Services\Invoice\Traits\TaxTrait;
use App\Services\Traits\HasWhen;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Storage;

class InvoiceService extends AppService
{
    use HasWhen, TaxTrait;

    public function __construct(Invoice $model, protected ProductStockService $productStockService)
    {
        $this->model = $model;
    }

    public function removeProduct($invoice): static
    {
        if (count(request()->get('remove_product'))) {
            $invoice->invoiceDetails()
                ->whereIn('id', request()->get('remove_product'))
                ->get()
                ->each(function (InvoiceDetail $detail) {
                    if ($detail->product) {
                        $this->productStockService->adjustStock(
                            $detail->product,
                            (float)$detail->quantity,
                            'sale_reversal',
                            Invoice::class,
                            $detail->invoice_id,
                            'Invoice product removed'
                        );
                    }
                    $detail->delete();
                });
        }
        return $this;
    }

    public function removeTax($invoice): static
    {
        if (count(request('remove_tax'))) {
            $invoice->taxes()->whereIn('id', request('remove_tax'))->delete();
        }
        return $this;
    }

    public function invoiceDetails(): InvoiceService
    {
        foreach (request('products') as $product) {

            if (isset($product['id'])) {
                $invoiceDetail = InvoiceDetail::query()->find($product['id']);
                if (!$invoiceDetail) {
                    continue;
                }

                $oldQuantity = (float)$invoiceDetail->quantity;
                $oldProductId = (int)$invoiceDetail->product_id;
                $newQuantity = (float)$product['quantity'];
                $newProductId = (int)$product['product_id'];

                if ($oldProductId !== $newProductId) {
                    $oldProduct = Product::query()->find($oldProductId);
                    $newProduct = Product::query()->find($newProductId);

                    if ($oldProduct) {
                        $this->productStockService->adjustStock(
                            $oldProduct,
                            $oldQuantity,
                            'sale_reversal',
                            Invoice::class,
                            $this->model->id,
                            'Invoice product changed'
                        );
                    }
                    if ($newProduct) {
                        $this->productStockService->adjustStock(
                            $newProduct,
                            -1 * $newQuantity,
                            'sale',
                            Invoice::class,
                            $this->model->id,
                            'Invoice product changed'
                        );
                    }
                } else {
                    $quantityDelta = $newQuantity - $oldQuantity;
                    if ($quantityDelta != 0) {
                        $currentProduct = Product::query()->find($newProductId);
                        if ($currentProduct) {
                            $this->productStockService->adjustStock(
                                $currentProduct,
                                -1 * $quantityDelta,
                                $quantityDelta > 0 ? 'sale' : 'sale_reversal',
                                Invoice::class,
                                $this->model->id,
                                'Invoice quantity updated'
                            );
                        }
                    }
                }

                $invoiceDetail->update([
                    'quantity' => $newQuantity,
                    'price' => $product['price'],
                    'product_id' => $newProductId,
                ]);
            } else {
                $this->model->invoiceDetails()->create([
                    'quantity' => $product['quantity'],
                    'price' => $product['price'],
                    'product_id' => $product['product_id'],
                ]);
                $productModel = Product::query()->find($product['product_id']);
                if ($productModel) {
                    $this->productStockService->adjustStock(
                        $productModel,
                        -1 * (float)$product['quantity'],
                        'sale',
                        Invoice::class,
                        $this->model->id,
                        'Invoice created'
                    );
                }
            }
        }
        return $this;
    }

    public function invoiceTax(): static
    {
        return $this->taxes();
    }

    public function deleteInvoiceDetails(): InvoiceService
    {
        $this->model->invoiceDetails->each(function (InvoiceDetail $detail) {
            if ($detail->product) {
                $this->productStockService->adjustStock(
                    $detail->product,
                    (float)$detail->quantity,
                    'sale_reversal',
                    Invoice::class,
                    $detail->invoice_id,
                    'Invoice deleted'
                );
            }
            $detail->delete();
        });

        return $this;
    }

    public function deleteInvoiceTaxes(): InvoiceService
    {
        $this->model->taxes()->delete();

        return $this;
    }

    public function transaction($request): static
    {

        $transaction = Transaction::query()->create([
            'invoice_id' => $this->model->id,
            'customer_id' => $this->model->customer_id,
            'payment_method_id' => $request['payment_method_id'],
            'received_on' => $request['received_on'],
            'amount' => $request['paying_amount'] ?? $this->model->due_amount,
            'note' => $request['note'] ?? '',
            'received_by' => $request['user_id'] ?? auth()->id()
        ]);

        $this->updateInvoice($transaction);

        return $this;
    }

    private function updateInvoice($transaction): static
    {
        $duePayment = ($this->model->due_amount - $transaction->amount);

        $this->model->update([
            'due_amount' => $duePayment,
            'received_amount' => ($this->model->received_amount + $transaction->amount),
            'status_id' => $duePayment == 0 ? resolve(StatusRepository::class)->invoicePaid() : resolve(StatusRepository::class)->invoiceDue()
        ]);
        return $this;
    }

    public function loadInvoiceInfo(): Invoice
    {
        return $this->model->load(['invoiceDetails' => function ($query) {
            $query->with('product:id,name');
        }, 'taxes', 'customer:id,first_name,last_name,email', 'customer.userProfile', 'customer.billingAddress']);

    }

    public function pdfGenerate($invoiceInfo): static
    {
        $pdf = $this->getPdf($invoiceInfo);

        $output = $pdf->output();
        $filePath = $this->getAttribute('file_path');
        Storage::put($filePath, $output);

        return $this;
    }

    public function sendInvoiceAttachment($invoice): static
    {
        InvoiceAttachmentJob::dispatch($invoice)->onQueue('high');
        return $this;
    }

    public function sendRecurringAttachmentMail($invoice): void
    {
        Mail::to(optional($invoice->customer)->email)
            ->send((new InvoiceRecurringMail($invoice)));
    }

    public function getPdf($invoiceInfo): \Barryvdh\DomPDF\PDF
    {
        $invoiceSetting = resolve(CustomizationService::class)->index('invoice');
        $invoiceLogo = config('app.url') . $invoiceSetting['invoice_logo'];

        if ($invoiceInfo->invoice_template == 2) {
            $pdf = PDF::loadView('pdf.invoice.invoice_two', [
                'invoice' => $invoiceInfo,
                'invoice_logo' => $invoiceLogo
            ]);
        } elseif ($invoiceInfo->invoice_template == 3) {
            $pdf = PDF::loadView('pdf.invoice.invoice_three', [
                'invoice' => $invoiceInfo,
                'invoice_logo' => $invoiceLogo
            ]);

        } else {
            $pdf = PDF::loadView('pdf.invoice.invoice', [
                'invoice' => $invoiceInfo,
                'invoice_logo' => $invoiceLogo
            ]);
        }
        return $pdf;
    }
}
