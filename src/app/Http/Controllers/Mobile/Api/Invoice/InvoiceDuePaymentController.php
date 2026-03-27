<?php

namespace App\Http\Controllers\Mobile\Api\Invoice;

use App\Exceptions\GeneralException;
use App\Helpers\Core\Traits\FirebaseNotificationTrait;
use App\Http\Controllers\Controller;
use App\Http\Requests\Mobile\Invoice\InvoiceDuePaymentRequest;
use App\Jobs\Invoice\Invoice\InvoiceAttachmentJob;
use App\Models\Invoice\Invoice\Invoice;
use App\Repositories\Core\StatusRepository;
use App\Services\Invoice\Invoice\InvoiceService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Symfony\Component\Mailer\Exception\TransportException;

class InvoiceDuePaymentController extends Controller
{
    use FirebaseNotificationTrait;

    public function __construct(InvoiceService $service)
    {
        $this->service = $service;
    }

    public function duePayment(InvoiceDuePaymentRequest $request, Invoice $invoice)
    {
        if (round($invoice->due_amount, 2) < round($request->paying_amount, 2)) {

            return error_response('Exceed Amount! Please put the correct amount.');
        }

        $checkInvoiceStatus = $invoice
            ->where('status_id', resolve(StatusRepository::class)->invoiceDue())
            ->exists();

        if (!$checkInvoiceStatus) {
            return error_response('Invoice is already paid');
        }

        try {
            DB::beginTransaction();

            $this->service
                ->setModel($invoice)
                ->transaction($request);

           $this->service
               ->setAttribute('file_path', 'public/pdf/invoice_' . $invoice->invoice_full_number . '.pdf')
               ->pdfGenerate($invoice);

           InvoiceAttachmentJob::dispatch($invoice, 'payment_received')->onQueue('high');
 
            // Construct the body message for the notification
            $bodyMessage = sprintf(
                'A payment of %s has been received for invoice %s.',
                number_format($request->paying_amount, 2),
                $invoice->invoice_full_number
            );

            // Send firebase notification to the author
            $this->sendFcmNotification('Payment Received', $bodyMessage, [$invoice->created_by],'payment');
        
            DB::commit();

            return success_response('Invoice payment has been successfully');

        }
         catch (TransportException $exception) {
            return error_response('Email setup is not correct', null, 402);
        }
         catch (\Exception $exception) { 
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response('Invoice payment has been field', null, 402);
            }
            return error_response($exception->getMessage(), null, 402);
        }
    }
}
