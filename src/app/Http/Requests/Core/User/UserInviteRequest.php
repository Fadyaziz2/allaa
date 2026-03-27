<?php

namespace App\Http\Requests\Core\User;

use App\Http\Controllers\Core\Setting\EmailDeliveryCheckController;
use Illuminate\Foundation\Http\FormRequest;

class UserInviteRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool|\Illuminate\Foundation\Application|\Illuminate\Http\Response|\Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\Routing\ResponseFactory
    {
        $checkEmailSetup = resolve(EmailDeliveryCheckController::class)->isExists();
        if (!$checkEmailSetup) {
            return response([
                'status' => false,
                'message' => trans('default.first_your_email_setup')
            ], 403);
        }
        return true;
    }


    public function rules(): array
    {

        return [
            'email' => ['required', 'email:strict', 'unique:users,email'],
            'role' => ['required'],
        ];
    }

}
