<?php

namespace App\Http\Requests\Invoice\PaymentMethod;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class PaymentMethodRequest extends FormRequest
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
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
     */
    public function rules(): array
    {

        return [
            'name' => ['required', 'string'],
            'type' => ['required', 'in:others,paypal,stripe,razorpay,sslcommerz',
                Rule::when((request('type') === 'stripe' || request('type') === 'paypal' || request('type') === 'razorpay') || (request('type') === 'sslcommerz'),
                    Rule::unique('payment_methods')->ignore($this->payment_method))
            ],
            'api_key' => [Rule::when((request('type') === 'stripe' || request('type') === 'paypal' || request('type') === 'razorpay') || (request('type') === 'sslcommerz'), ['required'])],
            'api_secret' => [Rule::when((request('type') === 'stripe' || request('type') === 'paypal' || request('type') === 'razorpay') || (request('type') === 'sslcommerz'), ['required'])],
        ];
    }

    public function messages(): array
    {
        return [
            'type.in' => 'The selected type only can be others,paypal,stripe,razorpay',
        ];
    }
}
