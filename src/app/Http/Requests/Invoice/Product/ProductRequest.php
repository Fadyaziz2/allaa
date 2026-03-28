<?php

namespace App\Http\Requests\Invoice\Product;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ProductRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        $sku = $this->input('sku') ?: $this->input('code');

        $this->merge([
            'sku' => $sku,
            'code' => $this->input('code') ?: $sku,
        ]);
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        $productId = $this->route('product')?->id;

        return [
            'name' => ['required', 'string', 'max:255'],
            'price' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'sku' => ['required', 'max:50', Rule::unique('products', 'sku')->ignore($productId)],
            'code' => ['nullable', 'max:50'],
            'unit_id' => ['nullable', 'exists:units,id'],
            'category_id' => ['nullable', 'exists:categories,id'],
            'description' => ['nullable', 'string'],
        ];
    }
}
