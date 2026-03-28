<?php

namespace App\Http\Requests\Invoice\Purchase;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use Illuminate\Foundation\Http\FormRequest;

class PurchaseInvoiceRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $id = $this->route('purchase_invoice')?->id;

        return [
            'supplier_id' => ['required', 'exists:suppliers,id'],
            'invoice_number' => ['required', 'string', 'max:191', 'unique:purchase_invoices,invoice_number,' . $id],
            'invoice_date' => ['required', 'date'],
            'discount' => ['nullable', 'numeric', 'min:0', new MaxDigitsPrecision(16)],
            'tax' => ['nullable', 'numeric', 'min:0', new MaxDigitsPrecision(16)],
            'paid_amount' => ['nullable', 'numeric', 'min:0', new MaxDigitsPrecision(16)],
            'note' => ['nullable', 'string'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.product_id' => ['required', 'exists:products,id'],
            'items.*.quantity' => ['required', 'numeric', 'gt:0', new MaxDigitsPrecision(16)],
            'items.*.unit_price' => ['required', 'numeric', 'min:0', new MaxDigitsPrecision(16)],
        ];
    }
}
