<?php

namespace App\Http\Controllers\Mobile\Api\Estimate;

use App\Exceptions\GeneralException;
use App\Filters\Invoice\Estimate\EstimateFilter;
use App\Helpers\Core\Traits\FirebaseNotificationTrait;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Core\Setting\EmailDeliveryCheckController;
use App\Http\Requests\Invoice\Estimate\EstimateRequest;
use App\Http\Resources\Mobile\Estimate\EstimateResourceCollection;
use App\Http\Resources\Mobile\Estimate\EstimateShowResource;
use App\Models\Core\Status\Status;
use App\Models\Invoice\Estimate\Estimate;
use App\Repositories\Core\StatusRepository;
use App\Services\Invoice\Estimate\EstimateService;
use Exception;
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

    /**
     * Display a listing of the resource.
     */
    public function index(): \Illuminate\Http\JsonResponse
    {
        $estimates = Estimate::query()
            ->filter($this->filter)
            ->select('id', 'customer_id', 'invoice_full_number', 'date', 'grand_total', 'status_id')
            ->with(['customer:id,first_name,last_name', 'status:id,name,class'])
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new EstimateResourceCollection($estimates));
    }

    public function store(EstimateRequest $request)
    {
        if ($request->sub_total < $request->discount_amount) {
            return error_response(trans('default.your_discount_amount_is_higher_in_subtotal'));
        }
        try {
            DB::beginTransaction();
            $request['status_id'] = resolve(StatusRepository::class)->estimatePending();
            $estimate = $this->service
                ->setAttributes($request->only(
                    'customer_id',
                    'date',
                    'sub_total',
                    'total_amount',
                    'grand_total',
                    'estimate_template',
                    'status_id')
                )->save();

            $this->service->when($request->get('products'), fn(EstimateService $service) => $service->estimateDetails());
            $this->service->when(count($request->get('taxes')), fn(EstimateService $service) => $service->estimateTax());

            $estimateInfo = $this->service->estimateInfo();

            if ($request->submit_type === 'send') {
                $this->setAttachment($estimateInfo);
            }


            // Construct the body message for the notification
            $bodyMessage = sprintf(
                'A new quotation %s has been created with a total amount of %s.',
                $estimate->invoice_full_number,
                number_format($estimate->total_amount, 2)
            );

            // Send firebase notification to the customer
            $this->sendFcmNotification('New Quotation Created', $bodyMessage, [$estimate->customer_id],'estimate');

            DB::commit();

            return success_response('Estimate created successfully');

        } catch (TransportException $exception) {
            DB::rollBack();
            return error_response(trans('default.email_setup_is_not_correct'));
        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response(trans('default.estimate_has_been_created_failed'));
            }
            return error_response($exception->getMessage());
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Estimate $estimate): \Illuminate\Http\JsonResponse
    {
        return success_response('Data fetched successfully', EstimateShowResource::make($estimate->load('estimateDetails')));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(EstimateRequest $request, Estimate $estimate): \Illuminate\Http\JsonResponse
    {
        try {
            DB::beginTransaction();
            $this->service
                ->setModel($estimate)
                ->setAttributes(array_merge($request->all(), [
                    'status_id' => resolve(StatusRepository::class)->estimatePending()
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

            return success_response('Estimate updated successfully');

        } catch (TransportException $exception) {
            DB::rollBack();
            return error_response(trans('default.email_setup_is_not_correct'));
        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response(trans('default.estimate_has_been_updated_failed'));
            }
            return error_response($exception->getMessage());
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Estimate $estimate): \Illuminate\Http\JsonResponse
    {
        try {
            DB::beginTransaction();
            $this->service
                ->setModel($estimate)
                ->deleteEstimateDetails()
                ->deleteEstimateTax()
                ->delete();

            DB::commit();
            return success_response('Estimate deleted successfully');
        } catch (Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response(trans('default.estimate_has_been_deleted_failed'));
            }
            return error_response($exception->getMessage());
        }
    }

    private function setAttachment($estimateInfo): void
    {
        $this->service
            ->setAttribute('file_path', 'public/pdf/estimate_' . $estimateInfo->invoice_full_number . '.pdf')
            ->pdfGenerate($estimateInfo)
            ->sendEstimateAttachment($estimateInfo);
    }

    public function sendAttachment(Estimate $estimate): \Illuminate\Http\JsonResponse
    {
        try {
            $estimateInfo = $this->service->setModel($estimate)->estimateInfo();
            $this->service
                ->setAttribute('file_path', 'public/pdf/estimate_' . $estimateInfo->invoice_full_number . '.pdf')
                ->pdfGenerate($estimateInfo)
                ->sendEstimateAttachment($estimateInfo);
            return success_response(trans('default.estimate_re_send_send_has_been_successfully'));
        } catch (TransportException $exception) {
            return error_response(trans('default.email_setup_is_not_correct'));
        } catch (\Exception $exception) {
            return error_response(trans('default.estimate_re_send_has_been_field'), 500);
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
            $this->sendFcmNotification('Quotation Status Updated', $bodyMessage, [$customerId],'estimate');
        } else {
            // Status was changed by the customer, notify the estimate creator
            $bodyMessage = sprintf(
                'The status of quotation %s has been changed by the customer to %s.',
                $estimate->invoice_full_number,
                $status->translated_name
            );

            // Send firebase notification to the estimate creator
            $this->sendFcmNotification('Quotation Status Changed by Customer', $bodyMessage, [$estimate->created_by],'estimate');
        }

        return success_response('Estimate status changed successfully');
    }
}
