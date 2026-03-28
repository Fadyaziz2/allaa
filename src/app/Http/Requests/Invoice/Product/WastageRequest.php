<?php

namespace App\Http\Requests\Invoice\Product;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use Illuminate\Foundation\Http\FormRequest;

class WastageRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'product_id' => ['required', 'exists:products,id'],
            'quantity' => ['required', 'numeric', 'gt:0', new MaxDigitsPrecision(16)],
            'note' => ['nullable', 'string', 'max:1000'],
        ];
    }
}
