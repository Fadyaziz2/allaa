<?php

namespace App\Http\Requests\Core\User;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UserProfileRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }


    public function rules(): array
    {
        $rules = [
            'first_name' => ['required', 'string', 'max:50'],
            'last_name' => ['required', 'string', 'max:30'],
            'email' => ['required', 'email', Rule::unique('users')->ignore(auth()->user())],
            'phone_number' => ['required_with:phone_country'],
            'phone_country' => ['required_with:phone_number'],
            'gender' => 'nullable|in:male,female,others',
            'address' => 'nullable|min:5|max:250',
            'date_of_birth' => 'nullable|date',
        ];

        if (env('APP_ENV') === 'production') {
            $rules['phone_number'][] = 'phone:INTERNATIONAL';
        }

        if (auth()->id()) {
            $rules['phone_number'][] = Rule::unique('user_profiles')->ignore(auth()->user()->userProfile()->first());
        } else {
            $rules['phone_number'][] = Rule::unique('user_profiles');
        }
        return $rules;
    }
    /**
     * Get custom attributes for validator errors.
     *
     * @return array<string, string>
     */
    public function attributes(): array
    {
        return [
            'phone_number' => __('default.phone_number'),
            'gender' => __('default.gender'),
            'address' => __('default.address'),
        ];
    }
    /**
     * Get the error messages for the defined validation rules.
     *
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'phone_number' => 'Please enter a valid phone number!',
        ];
    }
}
