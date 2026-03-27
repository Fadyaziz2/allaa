<?php

namespace App\Http\Requests\Invoice\Product;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use Illuminate\Contracts\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\ValidationException;

class ProductRequest extends FormRequest
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
     * @return array<string, Rule|array|string>
     */
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'price' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'code' => ['required', 'max:50'],
            'unit_id' => ['nullable', 'exists:units,id'],
            'category_id' => ['nullable', 'exists:categories,id'],
        ];
    }
}
