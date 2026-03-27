<?php

namespace App\Http\Requests\Core\User;

use Illuminate\Foundation\Http\FormRequest;

class UserJoinRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\Rule|array|string>
     */
    public function rules(): array
    {
        return [
            'token' => 'required',
            'first_name' => 'required|max:255',
            'last_name' => 'required|max:255',
            'password' => ['required', 'min:8', 'confirmed', 'regex:/^(?=[^\d]*\d)(?=[A-Z\d ]*[^A-Z\d ]).{8,}$/i'],
        ];
    }

    public function messages(): array
    {
        return [
            'password.regex' => __('default.password_user_gide_message')
        ];
    }
}
