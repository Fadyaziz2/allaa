<?php

namespace App\Http\Requests\Mobile\Invoice;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use Illuminate\Foundation\Http\FormRequest;

class InvoiceDuePaymentRequest extends FormRequest
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
        return [
            'payment_method_id' => ['required', 'numeric', 'exists:payment_methods,id'],
            'received_on' => ['required', 'date'],
            'paying_amount' => ['required', 'numeric', new MaxDigitsPrecision(16)],
        ];
    }

    public function messages(): array
    {
        return [
            'payment_method_id.required' => 'The payment method field is required.'
        ];
    }
}
