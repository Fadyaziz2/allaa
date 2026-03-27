<?php

namespace App\Http\Controllers\Mobile\Api\Setting;

use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Product\ProductResourceCollection;
use App\Http\Resources\Mobile\Setting\SettingResource;
use App\Repositories\Core\UserRepository;
use App\Services\Core\Setting\SettingService;
use Illuminate\Http\Request;

class ApiSettingController extends Controller
{
    public function __construct(SettingService $setting)
    {
        $this->service = $setting;
    }

    public function index()
    {
        if (auth()->check()) {

            $settings = array_merge($this->service->getFormattedSettings(), [
                'permissions' => array_merge(
                    resolve(UserRepository::class)->getPermissionsForFrontEnd(),
                    [
                        'is_app_admin' => auth()->user()->isAppAdmin(),
                        'is_customer' => auth()->user()->isCustomer(),
                    ]
                ),
            ]);

            return success_response('Data fetched successfully', new SettingResource($settings));

        }

        return success_response('Data fetched successfully', new SettingResource($this->service->getFormattedSettings()));
    }
}
