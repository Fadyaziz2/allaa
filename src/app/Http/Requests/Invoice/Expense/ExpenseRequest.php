<?php

namespace App\Http\Requests\Invoice\Expense;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use Illuminate\Foundation\Http\FormRequest;

class ExpenseRequest extends FormRequest
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
     * @return array<string, \Illuminate\Contracts\Validation\Rule|array|string>
     */
    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'date' => ['required', 'date'],
            'reference' => ['max:255'],
            'amount' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'category_id' => ['required', 'exists:categories,id'],
            'attachments.*' => request()->file('attachments') ? ['nullable', 'mimes:jpeg,png,jpg,gif,svg,pdf,zip,doc,xls', 'max:1024'] : [],
        ];
    }

    public function attributes(): array
    {
        return [
            'category_id' => 'expense category'
        ];
    }

    public function messages(): array
    {
        return [
            'attachments.*.mimes' => 'Allowed file types: jpeg, jpg, gif, png, pdf, zip, doc, xls',
            'attachments.*.max' => 'Sorry! Maximum allowed size for an image is 1MB',
        ];
    }
}
