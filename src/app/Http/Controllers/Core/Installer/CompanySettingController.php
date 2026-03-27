<?php

namespace App\Http\Controllers\Core\Installer;

use App\Http\Controllers\Controller;
use App\Services\Core\Setting\SettingService;
use Illuminate\Http\Request;

class CompanySettingController extends Controller
{
    public function __construct(SettingService $setting)
    {
        $this->service = $setting;
    }

    public function update(Request $request)
    {

        $request->validate([
            'company_name' => ['required', 'string', 'max:100'],
            'company_phone' => ['required', 'string', 'max:100'],
            'company_address' => ['required'],
            'company_logo' => ['required', 'image'],
            'company_icon' => ['required', 'image'],
            'company_banner' => ['required', 'image'],
        ]);

        $this->service->update();

        return updated_responses('settings', [
            'settings' => $this->service->getFormattedSettings()
        ]);
    }
}
