<?php

namespace App\Http\Controllers\Invoice\Customer;

use App\Exceptions\GeneralException;
use App\Filters\Core\User\UserFilter;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Core\Setting\EmailDeliveryCheckController;
use App\Http\Requests\Invoice\Customer\CustomerRequest;
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

    public function index()
    {
        return $this->service
            ->filter($this->filter)
            ->whereHas('roles', fn(Builder $query) => $query->where('alias', 'customer'))
            ->with('country:id,name', 'profilePicture', 'userProfile', 'status:id,name,class')
            ->orderByRaw('CONCAT(first_name, " ", last_name) ASC')
            ->paginate(request('per_page', 10));
    }

    /**
     * Store a newly created resource in storage.
     * @throws GeneralException
     */
    public function store(CustomerRequest $request)
    {
        if (isset($request->portal_access) && count($request->portal_access) > 0) {
            $checkEmailSetup = resolve(EmailDeliveryCheckController::class)->isExists();
            if (!$checkEmailSetup) {
                return response([
                    'status' => false,
                    'message' => trans('default.first_your_email_setup')
                ], 403);
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
                    ->userProfile($customer)
                    ->billingInfo($customer)
                    ->portalInvitation();
            });

            DB::commit();
            return created_responses('customers');
        } catch (\Exception $exception) {
            DB::rollBack();
            throw new GeneralException(__('customer_create_has_been_failed'));
        }


    }

    /**
     * Display the specified resource.
     */
    public function show(User $customer)
    {
        return $customer->load('userProfile', 'billingAddress');
    }

    /**
     * Update the specified resource in storage.
     * @throws GeneralException
     */
    public function update(CustomerRequest $request, User $customer)
    {
        if (isset($request->portal_access) && count($request->portal_access) > 0) {
            $checkEmailSetup = resolve(EmailDeliveryCheckController::class)->isExists();
            if (!$checkEmailSetup) {
                return response([
                    'status' => false,
                    'message' => trans('default.first_your_email_setup')
                ], 403);
            }
        }
        try {

            DB::transaction(function () use ($request, $customer) {
                $this->service
                    ->setModel($customer)
                    ->setAttributes($request->all())
                    ->update()
                    ->userProfile($customer)
                    ->billingInfo($customer)
                    ->portalInvitation();

            });

            DB::commit();

            return updated_responses('customers');

        } catch (\Exception $exception) {
            DB::rollBack();
            throw new GeneralException(__('customer_create_has_been_failed'));
        }

    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $customer)
    {
        $this->service
            ->setModel($customer)
            ->userProfileDelete()
            ->billingAddressDelete()
            ->delete();
        return deleted_responses('customers');
    }

    public function reSendPortalAccess(Request $request, User $customer): \Illuminate\Http\JsonResponse
    {
        $this->service
            ->setModel($customer)
            ->setAttributes($request->all())
            ->resendPortalAccessMail()
            ->updateProfilePortal();

        return response()->json([
            'message' => __('default.re_send_portal_access_mail_has_been_successfully')
        ]);
    }
}
