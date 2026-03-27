<?php

namespace App\Http\Controllers\Invoice\Invoice;

use App\Exceptions\GeneralException;
use App\Helpers\Core\Traits\FirebaseNotificationTrait;
use App\Http\Controllers\Controller;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\Invoice\InvoiceDetail;
use App\Models\Invoice\Invoice\InvoiceTax;
use App\Repositories\Core\StatusRepository;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use const _PHPStan_978789531\__;

class InvoiceCloneController extends Controller
{

    use FirebaseNotificationTrait;

    /**
     * @throws GeneralException
     */
    public function store(Request $request, Invoice $invoice)
    {

        try {
            DB::beginTransaction();
            $newInvoice = $invoice->replicate();
            $newInvoice->recurring = $request->recurring ?? $invoice->recurring;
            $newInvoice->status_id = resolve(StatusRepository::class)->invoiceDue();
            $newInvoice->received_amount = 0;
            $newInvoice->due_amount = $invoice->grand_total;
            $newInvoice->created_at = Carbon::now();
            $newInvoice->save();

            foreach ($invoice->invoiceDetails as $item) {
                InvoiceDetail::query()->create([
                    'quantity' => $item->quantity,
                    'price' => $item->price,
                    'invoice_id' => $newInvoice->id,
                    'product_id' => $item->product_id
                ]);
            }

            foreach ($invoice->taxes as $item) {

                InvoiceTax::query()->create([
                    'tax_id' => $item->tax_id,
                    'invoice_id' => $newInvoice->id,
                    'total_amount' => $item->total_amount
                ]);
            }

            // Construct the body message for the notification
            $title = 'New Invoice Created';
            $bodyMessage = sprintf(
                'A new invoice %s has been cloned with an amount of %s.',
                $newInvoice->invoice_full_number,
                number_format($newInvoice->total_amount, 2)
            );

            // Send firebase notification to the customer
            $this->sendFcmNotification($title, $bodyMessage, [$newInvoice->customer_id],'invoice');

            DB::commit();

            return response()->json([
                'data' => $newInvoice,
                'message' => __('default.invoice_clone_has_been_successfully')
            ]);

        } catch (\Exception $exception) {
            DB::rollBack();
            throw new GeneralException(__('default.invoice_clone_has_been_failed'));
        }

    }
}
