<?php

namespace App\Http\Requests\Core\Auth;

use Illuminate\Foundation\Http\FormRequest;

class PasswordRequest extends FormRequest
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
     * @return array
     */
    public function rules(): array
    {
        return [
            'email' => ['required', 'email', 'exists:users']
        ];
    }

    public function messages(): array
    {
        return [
            'email.exists' => 'User not found! Please valid email address',
        ];
    }
}
