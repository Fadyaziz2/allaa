<?php

namespace App\Http\Controllers\Invoice\Customization;

use App\Http\Controllers\Controller;
use App\Services\Invoice\Customization\CustomizationService;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class EstimateSettingController extends Controller
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
            'estimate_prefix' => 'required',
            'estimate_serial_start' => 'required',
        ]);

        if ($request->file('estimate_logo')) {
            $this->validate($request, [
                'estimate_logo' => 'required|image|mimes:jpeg,png,jpg|max:1024',
            ], [
                'estimate_logo.max' => 'Sorry! Maximum allowed size for an image is 1MB'
            ]);
        }

        $this->service->update('estimate');

        return updated_responses('estimate');
    }
}
