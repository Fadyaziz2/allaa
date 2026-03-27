<?php

namespace App\Http\Controllers\Invoice\PaymentMethod;

use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\PaymentMethod\PaymentMethodRequest;
use App\Models\Invoice\PaymentMethod\PaymentMethod;
use App\Services\Core\Setting\SettingService;

class PaymentMethodController extends Controller
{

    public function __construct(SettingService $service)
    {
        $this->service = $service;
    }

    public function index()
    {
        return PaymentMethod::query()
            ->orderByDesc('id')
            ->paginate(request('per_page', 20));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(PaymentMethodRequest $request)
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

        return created_responses('payment_methods');
    }


    public function show(PaymentMethod $payment_method): PaymentMethod
    {
        return $payment_method->load('settings');
    }


    public function update(PaymentMethodRequest $request, PaymentMethod $payment_method)
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
        return updated_responses('payment_methods');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(PaymentMethod $payment_method)
    {
        $payment_method->settings()->delete();
        $payment_method->delete();
        return deleted_responses('payment_methods');
    }
}
