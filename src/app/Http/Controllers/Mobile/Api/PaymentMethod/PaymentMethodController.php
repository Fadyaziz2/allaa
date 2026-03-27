<?php

namespace App\Http\Controllers\Mobile\Api\PaymentMethod;

use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\PaymentMethod\PaymentMethodRequest;
use App\Http\Resources\Mobile\PaymentMethod\PaymentMethodResourceCollection;
use App\Http\Resources\Mobile\PaymentMethod\PaymentMethodShowResource;
use App\Models\Invoice\PaymentMethod\PaymentMethod;
use App\Services\Core\Setting\SettingService;
use Illuminate\Http\Request;

class PaymentMethodController extends Controller
{

    public function __construct(SettingService $service)
    {
        $this->service = $service;
    }

    /**
     * Display a listing of the resource.
     */
    public function index(): \Illuminate\Http\JsonResponse
    {
        $paymentMethods = PaymentMethod::query()
            ->select(['id', 'name', 'type'])
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new PaymentMethodResourceCollection($paymentMethods));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(PaymentMethodRequest $request): \Illuminate\Http\JsonResponse
    {
        $paymentMethod = PaymentMethod::query()->create($request->only('name', 'type'));


        foreach ($request->only('payment_mode', 'api_key', 'api_secret') as $key => $value) {

            $this->service->setDefaultSettings(
                $key,
                $value,
                $request->type,
                get_class($paymentMethod),
                $paymentMethod->id
            );
        }

        return success_response('Payment method created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(PaymentMethod $payment_method): \Illuminate\Http\JsonResponse
    {
        $payment = $payment_method->load('settings');
        return success_response('Data fetched successfully', PaymentMethodShowResource::make($payment));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(PaymentMethodRequest $request, PaymentMethod $payment_method): \Illuminate\Http\JsonResponse
    {
        $payment_method->update($request->only('name', 'type'));

        foreach ($request->only('payment_mode', 'api_key', 'api_secret') as $key => $value) {

            $this->service->setDefaultSettings(
                $key,
                $value,
                $request->type,
                get_class($payment_method),
                $payment_method->id
            );
        }

        return success_response('Payment method updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(PaymentMethod $payment_method): \Illuminate\Http\JsonResponse
    {
        $payment_method->settings()->delete();
        $payment_method->delete();

        return success_response('Payment method deleted successfully');
    }
}
