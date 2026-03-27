<?php

namespace App\Http\Controllers\Core\Setting;

use App\Http\Controllers\Controller;
use App\Mail\Core\Test\TestMail;
use App\Services\Core\Setting\EmailSettingService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;

class EmailDeliveryCheckController extends Controller
{

    public function __construct(EmailSettingService $service)
    {
        $this->service = $service;
    }

    public function isExists(): int
    {

        $default = $this->service->getDefaultSettings();

        $check = $this->service->getFormattedDeliverySettings([optional($default)->value, 'default_mail_email_name']);

        return count($check) ? 1 : 0;
    }

    public function sendTestMail(Request $request): \Illuminate\Http\JsonResponse
    {
        $request->validate([
            'email_address' => 'required|email',
            'subject' => 'required',
            'message' => 'required'
        ]);

        Mail::to($request->email_address)->send(new TestMail($request->all()));

        return response()->json([
            'message' => __('default.email_send_has_been_successfully')
        ]);

    }
}
