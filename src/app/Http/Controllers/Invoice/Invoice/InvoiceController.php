<?php

namespace App\Http\Controllers\Invoice\Invoice;

use App\Exceptions\GeneralException;
use App\Filters\Invoice\Invoice\InvoiceFilter;
use App\Helpers\Core\Traits\FirebaseNotificationTrait;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Invoice\InvoiceRequest;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\User;
use App\Repositories\Core\StatusRepository;
use App\Services\Invoice\Invoice\InvoiceService;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Symfony\Component\Mailer\Exception\TransportException;

class InvoiceController extends Controller
{

    use FirebaseNotificationTrait;

    public function __construct(InvoiceService $service, InvoiceFilter $filter)
    {
        $this->service = $service;
        $this->filter = $filter;
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return $this->service
            ->filter($this->filter)
            ->where('recurring', '<>', 3)
            ->with('status:id,name,class', 'recurringType:id,name')
            ->when(auth()->user()->can('manage_global_access'), fn($query) => $query->with('customer:id,first_name,last_name'))
            ->orderBy('id', request('orderBy', 'desc'))
            ->paginate(request('per_page', 10));
    }


    /**
     * Store a newly created resource in storage.
     * @throws ValidationException
     * @throws GeneralException
     */
    public function store(InvoiceRequest $request)
    {
        if (round($request->grand_total, 2) < round($request->received_amount, 2)) {
            throw ValidationException::withMessages(['received_amount' => 'Exceed Amount! Please put the correct amount.']);
        }

        try {
            DB::beginTransaction();
            $invoice = $this->service
                ->setAttributes($request->all())
                ->save(
                    array_merge($request->only(
                        'customer_id',
                        'issue_date',
                        'due_date',
                        'reference_number',
                        'recurring',
                        'recurring_type_id',
                        'sub_total',
                        'discount_type',
                        'discount_amount',
                        'total_amount',
                        'grand_total',
                        'received_amount',
                        'due_amount',
                        'note',
                    ), [
                        'invoice_template' => request('selected_invoice_template'),
                        'status_id' => $request->due_amount == 0 ? resolve(StatusRepository::class)->invoicePaid() : resolve(StatusRepository::class)->invoiceDue()
                    ])
                );

            $this->service->when($request->get('products'), fn(InvoiceService $service) => $service->invoiceDetails());
            $this->service->when(count($request->get('taxes')), fn(InvoiceService $service) => $service->invoiceTax());


            $invoiceInfo = $this->service->loadInvoiceInfo();

            if ($request->submit_type === 'send') {
                $this->setAttachment($invoice, $invoiceInfo);
            }

            // Construct the body message for the notification
            $title = 'New Invoice Created';
            $bodyMessage = sprintf(
                'A new invoice %s has been created with an amount of %s.',
                $invoice->invoice_full_number,
                number_format($invoice->total_amount, 2)
            );

            // Send firebase notification to the customer
            $this->sendFcmNotification($title, $bodyMessage, [$invoice->customer_id],'invoice');

            DB::commit();
            return created_responses('invoices',[
                'invoice' => $invoice,
                'pdfUrl' => route('invoice.thermal',$invoice->id)
            ]);
        } catch (TransportException $exception) {
            DB::rollBack();
            throw new GeneralException(__('default.email_setup_is_not_correct'), 400);
        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                throw new GeneralException(__('default.invoice_created_failed'), 400);
            }
            throw new GeneralException($exception->getMessage(), 400);
        }

    }

    /**
     * Display the specified resource.
     */
    public function show(Invoice $invoice): Invoice
    {
        return $invoice->load('invoiceDetails.product:id,name', 'taxes.tax');
    }

    /**
     * Update the specified resource in storage.
     * @throws ValidationException
     * @throws GeneralException
     */
    public function update(InvoiceRequest $request, Invoice $invoice)
    {
        if ($request->grand_total < $request->received_amount) {
            throw ValidationException::withMessages(['received_amount' => 'Exceed Amount! Please put the correct amount.']);
        }

        try {
            DB::beginTransaction();
            $this->service
                ->setModel($invoice)
                ->setAttributes($request->all())
                ->save(array_merge($request->only(
                    'customer_id',
                    'issue_date',
                    'due_date',
                    'reference_number',
                    'recurring',
                    'recurring_type_id',
                    'sub_total',
                    'discount_type',
                    'discount_amount',
                    'total_amount',
                    'grand_total',
                    'received_amount',
                    'due_amount',
                    'note',
                ), [
                    'invoice_template' => request('selected_invoice_template'),
                    'status_id' => $request->due_amount == 0 ? resolve(StatusRepository::class)->invoicePaid() : resolve(StatusRepository::class)->invoiceDue()
                ]));

            $this->service->when($request->get('products'), fn(InvoiceService $service) => $service->removeProduct($invoice)->invoiceDetails());
            $this->service->when($request->get('remove_tax'), fn(InvoiceService $service) => $service->removeTax($invoice));
            $this->service->when(count($request->get('taxes')), fn(InvoiceService $service) => $service->invoiceTax());

            $invoiceInfo = $this->service->loadInvoiceInfo();
            if ($request->submit_type === 'send') {
                $this->setAttachment($invoice, $invoiceInfo);
            }


            DB::commit();
            return updated_responses('invoices');

        } catch (TransportException $exception) {
            DB::rollBack();
            throw new GeneralException(__('default.email_setup_is_not_correct'), 400);
        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                throw new GeneralException(__('default.invoice_updated_failed'), 400);
            }
            throw new GeneralException($exception->getMessage(), 400);
        }

    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Invoice $invoice)
    {
        $this->service
            ->setModel($invoice)
            ->deleteInvoiceDetails()
            ->deleteInvoiceTaxes()
            ->delete();

        return deleted_responses('invoices');
    }

    /**
     * @throws GeneralException
     */
    public function sendAttachment(Invoice $invoice): \Illuminate\Http\JsonResponse
    {
        try {
            $invoiceInfo = $this->service->setModel($invoice)->loadInvoiceInfo();
            $this->setAttachment($invoice, $invoiceInfo);
            return response()->json([
                'message' => __('default.attachment_sent_successfully')
            ]);
        } catch (TransportException $exception) {
            throw new GeneralException(__('default.email_setup_is_not_correct'), 400);
        } catch (\Exception $exception) {
            if (app()->environment('production')) {
                throw new GeneralException(__('default.failed_to_send_the_attachment'), 400);
            }
            throw new GeneralException($exception->getMessage(), 400);
        }

    }

    public function setAttachment(\Illuminate\Database\Eloquent\Model $invoice, Invoice $invoiceInfo): static
    {
        $this->service
            ->setAttribute('file_path', 'public/pdf/invoice_' . $invoice->invoice_full_number . '.pdf')
            ->pdfGenerate($invoiceInfo)
            ->sendInvoiceAttachment($invoice);

        return $this;
    }
}
