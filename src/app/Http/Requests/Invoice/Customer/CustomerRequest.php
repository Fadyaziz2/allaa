<?php

namespace App\Http\Requests\Invoice\Customer;

use Exception;
use Stripe\Customer;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class CustomerRequest extends FormRequest
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
            'email' => ['required', 'email', Rule::unique('users')->ignore($this->customer)],
            'phone_number' => ['required_with:phone_country'],
            'phone_country' => ['required_with:phone_number'],
        ];

        if (env('APP_ENV') === 'production') {
            $rules['phone_number'][] = 'phone:INTERNATIONAL';
        }

        if ($this->customer) {
            $rules['phone_number'][] = Rule::unique('user_profiles')->ignore($this->customer->userProfile()->first());
        } else {
            $rules['phone_number'][] = Rule::unique('user_profiles');
        }

        return $rules;
    }

    public function messages(): array
    {
        return [
            'phone_number' => 'Please enter a valid phone number!'
        ];
    }
}
