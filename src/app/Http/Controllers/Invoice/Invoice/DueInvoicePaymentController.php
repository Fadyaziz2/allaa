<?php

namespace App\Http\Controllers\Invoice\Invoice;

use App\Exceptions\GeneralException;
use App\Http\Controllers\Controller;
use App\Jobs\Invoice\Invoice\InvoiceAttachmentJob;
use App\Models\Invoice\Invoice\Invoice;
use App\Paypal\CreatePayment;
use App\Services\Invoice\Invoice\InvoiceService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Symfony\Component\Mailer\Exception\TransportException;
use App\Helpers\Core\Traits\FirebaseNotificationTrait;

class DueInvoicePaymentController extends Controller
{

    use FirebaseNotificationTrait;


    public function __construct(InvoiceService $service)
    {
        $this->service = $service;
    }

    /**
     * @throws GeneralException
     * @throws ValidationException
     */
    public function duePayment(Request $request, Invoice $invoice)
    {
        $this->getValidate($request);


        if (round($invoice->due_amount, 2) < round($request->paying_amount, 2)) {
            throw ValidationException::withMessages(['paying_amount' => 'Exceed Amount! Please put the correct amount.']);
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
            return response()->json([
                'message' => __('default.invoice_payment_has_been_successfully')
            ]);
        } catch (TransportException $exception) {
            throw new GeneralException(__('default.email_setup_is_not_correct'));
        } catch (\Exception $exception) {
            DB::rollBack();
            throw new GeneralException(__('default.invoice_payment_has_been_field'), 402);
        }

    }


    public function getValidate(Request $request): void
    {
        $request->validate([
            'payment_method_id' => ['required', 'numeric', 'exists:payment_methods,id'],
            'received_on' => ['required', 'date'],
            'paying_amount' => ['required', 'numeric'],
        ], [
            'payment_method_id.required' => 'The payment method field is required.'
        ]);
    }
}
