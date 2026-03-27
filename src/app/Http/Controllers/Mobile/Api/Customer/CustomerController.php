<?php

namespace App\Http\Controllers\Mobile\Api\Customer;

use App\Exceptions\GeneralException;
use App\Filters\Core\User\UserFilter;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Core\Setting\EmailDeliveryCheckController;
use App\Http\Resources\Mobile\Customer\CustomerResourceCollection;
use App\Http\Resources\Mobile\Customer\CustomerShowResource;
use App\Models\Core\Status\Status;
use App\Models\User;
use App\Repositories\Core\StatusRepository;
use App\Services\Invoice\Customer\CustomerService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CustomerController extends Controller
{

    public function __construct(CustomerService $service, UserFilter $filter)
    {
        $this->service = $service;
        $this->filter = $filter;
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $customers = $this->service
            ->filter($this->filter)
            ->select('id', 'first_name', 'last_name', 'email', 'status_id')
            ->whereHas('roles', fn(Builder $query) => $query->where('alias', 'customer'))
            ->with(['profilePicture', 'status:id,name,class'])
            ->orderByRaw('CONCAT(first_name, " ", last_name) ASC')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new CustomerResourceCollection($customers));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'first_name' => 'required|max:50',
            'last_name' => 'required|max:30',
            'email' => 'required|email|max:150|unique:users,email',
            'phone_number' => 'nullable|max:50',
            'phone_country' => 'nullable|max:50',
            'portal_access' => 'nullable|boolean',
        ]);

        if ($request->has('portal_access') && $request->portal_access) {
            $checkEmailSetup = resolve(EmailDeliveryCheckController::class)->isExists();
            if (!$checkEmailSetup) {
                return error_response(trans('default.first_your_email_setup'));
            }
        }

        try {

            DB::transaction(function () use ($request) {
                $customer = $this->service
                    ->setAttributes($request->all())
                    ->save(array_merge($request->only('first_name', 'last_name', 'email'),
                        ['status_id' => resolve(StatusRepository::class)->userActive()]));

                $this->service
                    ->assignRole($customer)
                    ->mobileUserProfile($customer)
                    ->mobilePortalInvitation();
            });

            DB::commit();

            return success_response('Customer created successfully');

        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('local')) {
                return error_response($exception->getMessage(), 500);
            }
            return error_response(__('customer_create_has_been_failed'), 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(User $customer): \Illuminate\Http\JsonResponse
    {
        return success_response('Data fetched successfully', new CustomerShowResource($customer->load('userProfile')));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, User $customer): \Illuminate\Foundation\Application|\Illuminate\Http\Response|\Illuminate\Http\JsonResponse|\Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\Routing\ResponseFactory
    {
        if ($request->has('portal_access') && $request->portal_access) {
            $checkEmailSetup = resolve(EmailDeliveryCheckController::class)->isExists();
            if (!$checkEmailSetup) {
                return error_response(trans('default.first_your_email_setup'));
            }
        }

        $request->validate([
            'first_name' => 'required|max:50',
            'last_name' => 'required|max:30',
            'email' => 'required|email|max:150|unique:users,email,' . $customer->id,
            'phone_number' => 'nullable|max:50',
            'phone_country' => 'nullable|max:50',
            'portal_access' => 'nullable|boolean',
        ]);

        try {

            DB::transaction(function () use ($request, $customer) {
                $this->service
                    ->setModel($customer)
                    ->setAttributes($request->all())
                    ->update()
                    ->mobileUserProfile($customer)
                    ->mobilePortalInvitation();
            });

            DB::commit();

            return success_response('Customer updated successfully');

        } catch (\Exception $exception) {
            DB::rollBack();
            if (app()->environment('local')) {
                return error_response($exception->getMessage(), 500);
            }
            return error_response(__('customer_updated_has_been_failed'), 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $customer): \Illuminate\Http\JsonResponse
    {
        try {
            $this->service
                ->setModel($customer)
                ->userProfileDelete()
                ->billingAddressDelete()
                ->delete();

            return success_response('Customer deleted successfully');
        } catch (\Exception $exception) {
            if (app()->environment('local')) {
                return error_response($exception->getMessage(), 500);
            }
            return error_response('Customer delete has been failed!', 500);
        }

    }

    public function reSendPortalAccess(User $customer): \Illuminate\Http\JsonResponse
    {
        try {
            $this->service
                ->setModel($customer)
                ->setAttributes(request()->all())
                ->resendPortalAccessMail()
                ->updateProfilePortal();

            return success_response(trans('default.re_send_portal_access_mail_has_been_successfully'));
        } catch (\Exception $exception) {
            if (app()->environment('production')) {
                return error_response('Customer profile resend portal access has been failed', 500);
            }
            return error_response($exception->getMessage(), 500);
        }
    }

    public function updateStatus(Request $request, User $customer): \Illuminate\Http\JsonResponse
    {
        if ($customer->is_admin || $customer->id == auth()->id()) {
            return error_response(trans('default.action_not_allowed'));
        }

        $customer->update([
            'status_id' => Status::findByNameAndType($request->status_name)->id
        ]);

        return success_response('Customer status updated successfully');
    }
}
