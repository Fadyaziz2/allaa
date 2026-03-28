<?php

namespace App\Http\Requests\Invoice\Purchase;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use Illuminate\Foundation\Http\FormRequest;

class PurchasePaymentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'amount' => ['required', 'numeric', 'gt:0', new MaxDigitsPrecision(16)],
            'payment_date' => ['required', 'date'],
            'reference' => ['nullable', 'string', 'max:191'],
            'note' => ['nullable', 'string'],
        ];
    }
}
