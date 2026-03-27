<?php

namespace App\Http\Requests\Invoice\Invoice;

use App\Http\Controllers\Core\Setting\EmailDeliveryCheckController;
use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use Illuminate\Foundation\Http\FormRequest;

class InvoiceRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool|\Illuminate\Foundation\Application|\Illuminate\Http\Response|\Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\Routing\ResponseFactory
    {
        $checkEmailSetup = resolve(EmailDeliveryCheckController::class)->isExists();
        if (!$checkEmailSetup) {
            return response([
                'status' => false,
                'message' => trans('default.first_your_email_setup')
            ], 403);
        }
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
            'customer_id' => ['required', 'numeric', 'exists:users,id'],
            'issue_date' => ['required', 'date'],
            'due_date' => ['required', 'date'],
            'reference_number' => ['nullable', 'string'],
            'recurring' => ['required'],
            'recurring_type_id' => ['required_if:recurring,=,1'],
            'sub_total' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'discount_type' => ['nullable', 'in:none,fixed,percentage'],
            'discount_amount' => ['nullable',
                'required_if:discount_type,=,fixed',
                'required_if:discount_type,=,percentage',
                'numeric', new MaxDigitsPrecision(16)],
            'total_amount' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'received_amount' => ['nullable', 'numeric', new MaxDigitsPrecision(16)],
            'due_amount' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'note' => ['nullable', 'string'],
            'products' => ['required', 'array', 'min:1'],
            'products.*.quantity' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            'products.*.price' => ['required', 'numeric', new MaxDigitsPrecision(16)],
        ];
    }

    public function attributes(): array
    {
        return [
            'customer_id' => 'customer',
            'status_id' => 'status',
            'products.*.quantity' => 'quantity',
            'products.*.price' => 'price',
        ];
    }

    public function messages(): array
    {
        return [
            'recurring_type_id.required_if' => 'The recurring cycle field is required.',
            'discount_amount.required_if' => 'The discount amount field is required.',
        ];
    }
}
