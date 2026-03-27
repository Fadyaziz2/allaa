<?php

namespace App\Http\Controllers\Invoice\Customization;

use App\Http\Controllers\Controller;
use App\Services\Invoice\Customization\CustomizationService;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class InvoiceSettingController extends Controller
{
    public function __construct(CustomizationService $service)
    {
        $this->service = $service;
    }


    /**
     * @throws ValidationException
     */
    public function update(Request $request)
    {
        $this->validate($request, [
            'invoice_prefix' => 'required',
            'invoice_serial_start' => 'required',
        ]);

        if ($request->file('invoice_logo')) {
            $this->validate($request, [
                'invoice_logo' => 'required|image|mimes:jpeg,png,jpg|max:1024',
            ], [
                'invoice_logo.max' => 'Sorry! Maximum allowed size for an image is 1MB'
            ]);
        }

        $this->service->update('invoice');

        return updated_responses('invoice');
    }
}
