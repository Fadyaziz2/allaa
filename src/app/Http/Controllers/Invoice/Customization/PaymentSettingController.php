<?php

namespace App\Http\Controllers\Invoice\Customization;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\Invoice\Customization\CustomizationService;

class PaymentSettingController extends Controller
{
    public function __construct(CustomizationService $service)
    {
        $this->service = $service;
    }


    public function update(Request $request)
    {
        $this->validate($request, [
            'payment_prefix' => 'required',
            'payment_serial_start' => 'required',
        ]);
        if ($request->file('payment_logo')) {
            $this->validate($request, [
                'payment_logo' => 'required|image|mimes:jpeg,png,jpg|max:1024',
            ], [
            'payment_logo.max' => 'Sorry! Maximum allowed size for an image is 1MB'
            ]);
        }
        $this->service->update('payment');

        return updated_responses('payment_setting');
    }
}
