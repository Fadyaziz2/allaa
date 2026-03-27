<?php

namespace App\Http\Controllers\Core\Setting;

use App\Http\Controllers\Controller;
use App\Http\Requests\Core\Setting\EmailSettingRequest;
use App\Services\Core\Setting\EmailSettingService;

class EmailSettingController extends Controller
{
    public function __construct(EmailSettingService $service)
    {
        $this->service = $service;
    }

    public function index()
    {
        $default = $this->service->getDefaultSettings();

        return $this->service
            ->getFormattedDeliverySettings([optional($default)->value, 'default_mail_email_name']);
    }

    public function update(EmailSettingRequest $request)
    {
        $context = $request->get('provider');

        foreach ($request->only('from_name', 'from_email') as $key => $value) {

            $this->service
                ->update($key, $value, 'default_mail_email_name');
        }

        foreach ($request->except('allowed_resource', 'from_name', 'from_email') as $key => $value) {
            $this->service
                ->update($key, $value, $context);
        }

        $this->service->setDefaultSettings('default_mail', $context);

        return updated_responses('email_settings');
    }

    public function show($provider)
    {
        return $this->service
            ->getFormattedDeliverySettings([$provider, 'default_mail_email_name']);
    }
}
