<?php

namespace App\Http\Requests\Invoice\Estimate;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use Illuminate\Foundation\Http\FormRequest;

class EstimateRequest extends FormRequest
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
            'customer_id' => ['required', 'numeric', 'exists:users,id'],
            'date' => ['required', 'date'],
            'sub_total' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'discount_type' => ['nullable', 'in:none,fixed,percentage'],
            'discount_amount' => ['nullable',
                'required_if:discount_type,=,fixed',
                'required_if:discount_type,=,percentage',
                'numeric', new MaxDigitsPrecision(16)],
            'total_amount' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'note' => ['nullable', 'string'],
            'products' => ['required', 'array', 'min:1'],
            'products.*.quantity' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'products.*.price' => ['required', 'numeric', new MaxDigitsPrecision(16)],
        ];
    }

    public function attributes(): array
    {
        return [
            'customer_id' => 'customer'
        ];
    }
}
