<?php

namespace App\Http\Controllers\Core\Setting;

use App\Http\Controllers\Controller;
use App\Repositories\Core\UserRepository;
use App\Services\Core\Setting\SettingService;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class SettingController extends Controller
{
    public function __construct(SettingService $setting)
    {
        $this->service = $setting;
    }

    public function index()
    {
        if (auth()->check()) {
            return array_merge($this->service->getFormattedSettings(), [
                'permissions' => array_merge(
                    resolve(UserRepository::class)->getPermissionsForFrontEnd(),
                    [
                        'is_app_admin' => auth()->user()->isAppAdmin(),
                    ]
                ),
            ]);
        }
        if (env('PURCHASE_CODE') && config('theme29.installed')) {
            return $this->service->getFormattedSettings();
        }

        return [];
    }

    /**
     * @throws ValidationException
     */
    public function update(Request $request)
    {
        $this->validate($request, [
            'company_name' => 'required',
            'date_format' => 'required',
            'time_format' => 'required',
            'currency_symbol' => 'required',
            'time_zone' => 'required',
            'language' => 'required',
            'company_website' => 'nullable|url',
        ]);
        $this->ImageValidation($request);

        $this->service->update();

        return updated_responses('settings', [
            'settings' => $this->service->getFormattedSettings()
        ]);
    }

    public function generalSettings(): array
    {
        return [
            'date_format' => array_map(function ($format) {
                return ['id' => $format, 'name' => trans('default.' . $format)];
            }, config('settings.date_format')),

            'decimal_separator' => array_map(function ($format) {
                return ['id' => $format, 'name' => trans('default.' . $format)];
            }, config('settings.decimal_separator')),

            'thousand_separator' => array_map(function ($format) {
                return ['id' => $format, 'name' => trans('default.' . $format)];
            }, config('settings.thousand_separator')),

            'number_of_decimal' => array_map(function ($format) {
                return ['id' => $format, 'name' => trans('default.' . $format)];
            }, config('settings.number_of_decimal')),

            'currency_position' => array_map(function ($format) {
                return ['id' => $format, 'name' => trans('default.' . $format)];
            }, config('settings.currency_position')),

            'time_zones' => array_map(function ($format) {
                return [
                    'id' => $format,
                    'name' => $format
                ];
            }, timezone_identifiers_list()),
        ];
    }

    /**
     * @throws ValidationException
     */
    public function ImageValidation(Request $request): void
    {
        if ($request->file('company_logo')) {
            $this->validate($request, [
                'company_logo' => 'nullable|mimes:jpeg,png,jpg,svg|max:1024'
            ], [
                'company_logo.max' => 'Sorry! Maximum allowed size for an image is 1MB'
            ]);
        }

        if ($request->file('company_icon')) {
            $this->validate($request, ['company_icon' => 'nullable|mimes:jpeg,png,jpg,svg|max:1024'],
                [
                    'company_icon.max' => 'Sorry! Maximum allowed size for an image is 1MB'
                ]);

        }
        if ($request->file('company_banner')) {
            $this->validate($request, ['company_banner' => 'nullable|mimes:jpeg,png,jpg,svg|max:1024'],
                [
                    'company_banner.max' => 'Sorry! Maximum allowed size for an image is 1MB'
                ]);
        }
    }
}
