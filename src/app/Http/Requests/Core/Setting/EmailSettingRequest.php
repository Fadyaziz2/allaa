<?php

namespace App\Http\Requests\Core\Setting;

use Illuminate\Foundation\Http\FormRequest;

class EmailSettingRequest extends FormRequest
{


    public function authorize(): bool
    {
        return true;
    }


    public function rules(): array
    {
        $rules['provider'] = 'required';
        $rules['from_name'] = 'required';
        $rules['from_email'] = 'required|email';

        if (request()->get('provider') === 'smtp') {
            $rules['smtp_host'] = 'required';
            $rules['smtp_port'] = 'required|numeric';
            $rules['smtp_username'] = 'required';
            $rules['email_password'] = 'required';
            $rules['encryption_type'] = 'required';

        } elseif (request()->get('provider') === 'amazon_ses') {
            $rules['hostname'] = 'required';
            $rules['access_key_id'] = 'required';
            $rules['secret_access_key'] = 'required';

        } elseif (request()->get('provider') === 'mailgun') {
            $rules['domain_name'] = 'required';
            $rules['api_key'] = 'required';

        } elseif (request()->get('provider') === 'postmark') {
            $rules['token'] = 'required';
        }


        return $rules;
    }

}
