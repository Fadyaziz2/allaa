<?php

namespace App\Http\Controllers\Invoice\Estimate;

use App\Exceptions\GeneralException;
use App\Filters\Invoice\Estimate\EstimateFilter;
use App\Helpers\Core\Traits\FirebaseNotificationTrait;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Core\Setting\EmailDeliveryCheckController;
use App\Http\Requests\Invoice\Estimate\EstimateRequest;
use App\Models\Core\Status\Status;
use App\Models\Invoice\Estimate\Estimate;
use App\Repositories\Core\StatusRepository;
use App\Services\Invoice\Estimate\EstimateService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\Mailer\Exception\TransportException;

class EstimateController extends Controller
{

    use FirebaseNotificationTrait;

    public function __construct(EstimateService $service, EstimateFilter $filter)
    {
        $this->service = $service;
        $this->filter = $filter;
    }

    public function index()
    {
        return $this->service
            ->filter($this->filter)
            ->when(auth()->user()->can('manage_global_access'), fn($query) => $query->with('customer:id,first_name,last_name'))
            ->with(['status:id,name,class'])
            ->orderBy('id', request()->get('orderBy', 'desc'))
            ->paginate(request()->get('per_page', 10));
    }

    /**
     * Store a newly created resource in storage.
     * @throws GeneralException
     */
    public function store(EstimateRequest $request)
    {
        if ($request->sub_total < $request->discount_amount) {
            return error_response(trans('default.your_discount_amount_is_higher_in_subtotal'));
        }

        try {
            DB::beginTransaction();
            $request['status_id'] = resolve(StatusRepository::class)->estimatePending();
            $request['discount_type'] = $request->discount_type ?? 'none';
            $estimate = $this->service
                ->setAttributes($request->only(
                    'customer_id',
                    'date',
                    'discount_type',
                    'discount_amount',
                    'sub_total',
                    'total_amount',
                    'grand_total',
                    'estimate_template',
                    'status_id',
                    'note'
                )
                )->save();

            $this->service->when($request->get('products'), fn(EstimateService $service) => $service->estimateDetails());
            $this->service->when(count($request->get('taxes')), fn(EstimateService $service) => $service->estimateTax());

            $estimateInfo = $this->service->estimateInfo();
            if ($request->submit_type === 'send') {
                $this->setAttachment($estimateInfo);
            }

            // Construct the body message for the notification
            $title = 'New Quotation Created';
            $bodyMessage = sprintf(
                'A new quotation %s has been created with an amount of %s.',
                $estimate->invoice_full_number,
                number_format($estimate->total_amount, 2)
            );

            // Send firebase notification to the customer
            $this->sendFcmNotification($title, $bodyMessage, [$estimateInfo->customer_id], 'estimate');

            DB::commit();

            return created_responses('estimates',[
                'estimate' => $estimate
            ]);

        } catch (TransportException $exception) {
            DB::rollBack();
            throw new GeneralException(__('default.email_setup_is_not_correct'), 400);
        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                throw new GeneralException(__('default.estimate_has_been_created_failed'), 400);
            }
            throw new GeneralException($exception->getMessage(), 400);

        }
    }

    public function show(Estimate $estimate): Estimate
    {
        return $estimate->load('estimateDetails.product:id,name', 'taxes.tax');
    }

    /**
     * @throws GeneralException
     */
    public function update(EstimateRequest $request, Estimate $estimate)
    {
        if ($request->sub_total < $request->discount_amount) {
            return error_response(trans('default.your_discount_amount_is_higher_in_subtotal'));
        }

        try {
            DB::beginTransaction();
            $this->service
                ->setModel($estimate)
                ->setAttributes(array_merge($request->all(), [
                    'status_id' => resolve(StatusRepository::class)->estimatePending(),
                    'discount_type' => $request->discount_type ?? 'none',
                ]))
                ->update();

            $this->service->when($request->get('products'), fn(EstimateService $service) => $service->removeEstimateProduct($estimate)->estimateDetails());
            $this->service->when(count($request->get('remove_tax')), fn(EstimateService $service) => $service->removeEstimateTax($estimate));
            $this->service->when(count($request->get('taxes')), fn(EstimateService $service) => $service->estimateTax());

            $estimateInfo = $this->service->estimateInfo();

            if ($request->submit_type === 'send') {
                $this->setAttachment($estimateInfo);
            }
            DB::commit();

            return updated_responses('estimates');

        } catch (TransportException $exception) {
            DB::rollBack();
            throw new GeneralException(__('default.email_setup_is_not_correct'), 400);
        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                throw new GeneralException(__('default.estimate_has_been_updated_failed'), 400);
            }
            throw new GeneralException($exception->getMessage(), 400);
        }

    }

    public function destroy(Estimate $estimate)
    {
        $this->service
            ->setModel($estimate)
            ->deleteEstimateDetails()
            ->deleteEstimateTax()
            ->delete();

        return deleted_responses('estimates');
    }


    /**
     * @throws GeneralException
     */
    public function reSendMail(Estimate $estimate): \Illuminate\Http\JsonResponse
    {
        try {
            $estimateInfo = $this->service->setModel($estimate)->estimateInfo();
            $this->service
                ->setAttribute('file_path', 'public/pdf/estimate_' . $estimateInfo->invoice_full_number . '.pdf')
                ->pdfGenerate($estimateInfo)
                ->sendEstimateAttachment($estimateInfo);
            return response()->json([
                'message' => __('default.estimate_re_send_send_has_been_successfully')
            ]);
        } catch (TransportException $exception) {
            throw new GeneralException(__('default.email_setup_is_not_correct'), 400);
        } catch (\Exception $exception) {
            if (app()->environment('production')) {
                throw new GeneralException(__('default.estimate_re_send_has_been_field'), 400);
            }
            throw new GeneralException($exception->getMessage(), 400);
        }

    }


    public function statusChange(Request $request, Estimate $estimate): \Illuminate\Http\JsonResponse
    {
        // Get the current authenticated user's ID
        $currentUserId = auth()->id();

        // Get the customer who is linked with this estimate (assuming there's a relationship or a field indicating the customer)
        $customerId = $estimate->customer_id;


        // Find the status by name and type
        $status = Status::query()->where(['name' => $request->status, 'type' => 'estimate'])->first();

        // Update the estimate status
        $estimate->update([
            'status_id' => $status->id
        ]);

        // Check if the status was changed by the estimate creator
        if ($estimate->created_by == $currentUserId) {
            // Send notification to the customer
            $bodyMessage = sprintf(
                'The status of your quotation %s has been updated to %s.',
                $estimate->invoice_full_number,
                $status->translated_name
            );

            // Send firebase notification to the customer
            $this->sendFcmNotification('Quotation Status Updated', $bodyMessage, [$customerId], 'estimate');
        } else {
            // Status was changed by the customer, notify the estimate creator
            $bodyMessage = sprintf(
                'The status of quotation %s has been changed by the customer to %s.',
                $estimate->invoice_full_number,
                $status->translated_name
            );

            // Send firebase notification to the estimate creator
            $this->sendFcmNotification('Quotation status changed by customer', $bodyMessage, [$estimate->created_by], 'estimate');
        }

        return success_response('Estimate status changed successfully');
    }

    private function setAttachment($estimateInfo): void
    {
        $this->service
            ->setAttribute('file_path', 'public/pdf/estimate_' . $estimateInfo->invoice_full_number . '.pdf')
            ->pdfGenerate($estimateInfo)
            ->sendEstimateAttachment($estimateInfo);
    }

}
