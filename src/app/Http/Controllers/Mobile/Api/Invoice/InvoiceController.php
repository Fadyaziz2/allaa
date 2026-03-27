<?php

namespace App\Http\Controllers\Mobile\Api\Invoice;

use App\Exceptions\GeneralException;
use App\Filters\Invoice\Invoice\InvoiceFilter;
use App\Helpers\Core\Traits\FirebaseNotificationTrait;
use App\Http\Controllers\Controller;
use App\Http\Requests\Mobile\Invoice\InvoiceRequest;
use App\Http\Resources\Mobile\Invoice\InvoiceResourceCollection;
use App\Http\Resources\Mobile\Invoice\InvoiceShowResource;
use App\Models\Invoice\Invoice\Invoice;
use App\Repositories\Core\StatusRepository;
use App\Services\Invoice\Invoice\InvoiceService;
use Illuminate\Support\Facades\DB;
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
    public function index(): \Illuminate\Http\JsonResponse
    {
        $invoices = $this->service
            ->filter($this->filter)
            ->with(['customer:id,first_name,last_name', 'status:id,name,class'])
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Invoice data fetched successfully', new InvoiceResourceCollection($invoices));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(InvoiceRequest $request)
    {

        if (round($request->get('grand_total'), 2) < round($request->get('received_amount'), 2)) {
            return error_response('Exceed Amount! Please put the correct amount.', 403);
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
                        'sub_total',
                        'discount_type',
                        'discount_amount',
                        'total_amount',
                        'grand_total',
                        'received_amount',
                        'due_amount',
                        'note',
                    ), [
                        'recurring' => 0,
                        'invoice_template' => request('selected_invoice_template'),
                        'status_id' => $request->get('due_amount') == 0 ? resolve(StatusRepository::class)->invoicePaid() : resolve(StatusRepository::class)->invoiceDue()
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
            return created_responses('invoices');
        } catch (TransportException $exception) {
            DB::rollBack();
            return error_response('Email setup is not correct', 403);
        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response('Invoice created failed', 500);
            }
            return error_response($exception->getMessage(), 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Invoice $invoice): \Illuminate\Http\JsonResponse
    {
        return success_response('Invoice data fetched successfully', InvoiceShowResource::make($invoice->load('invoiceDetails.product:id,name', 'taxes.tax')));

    }

    /**
     * Update the specified resource in storage.
     */
    public function update(InvoiceRequest $request, Invoice $invoice)
    {
        if (round($request->get('grand_total'), 2) < round($request->get('received_amount'), 2)) {
            return error_response('Exceed Amount! Please put the correct amount.', 403);
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
            return error_response('Email setup is not correct', 403);
        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response('Invoice updated failed', 500);
            }
            return error_response($exception->getMessage(), 500);
        }

    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Invoice $invoice): \Illuminate\Http\JsonResponse
    {
        try {
            DB::beginTransaction();
            $this->service
                ->setModel($invoice)
                ->deleteInvoiceDetails()
                ->deleteInvoiceTaxes()
                ->delete();
            DB::commit();

            return success_response('Invoice deleted successfully');
        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response('Invoice deleted has been failed', 500);
            }
            return error_response($exception->getMessage(), 500);
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

    public function sendAttachment(Invoice $invoice): \Illuminate\Http\JsonResponse
    {
        try {
            $invoiceInfo = $this->service->setModel($invoice)->loadInvoiceInfo();
            $this->setAttachment($invoice, $invoiceInfo);
            return success_response(trans('default.attachment_sent_successfully'));
        } catch (TransportException $exception) {
            return error_response(trans('default.email_setup_is_not_correct'), 403);
        } catch (\Exception $exception) {
            if (app()->environment('production')) {
                return error_response(trans('default.failed_to_send_the_attachment'), 500);
            }
            return error_response($exception->getMessage(), 500);
        }

    }
}
