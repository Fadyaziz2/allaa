<?php

namespace App\Http\Resources\Mobile\Invoice;

use App\Http\Resources\Mobile\Comman\ItemDetailResource;
use App\Http\Resources\Mobile\Comman\TaxResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class InvoiceShowResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'invoice_template' => $this->invoice_template,
            'customer_id' => $this->customer_id,
            'issue_date' => $this->issue_date,
            'due_date' => $this->due_date,
            'reference_number' => $this->reference_number,
            'grand_total' => $this->grand_total,
            'received_amount' => $this->received_amount,
            'discount_type' => $this->discount_type,
            'discount_amount' => $this->discount_amount,
            'note' => $this->note,
            'invoice_details' => ItemDetailResource::collection($this->invoiceDetails),
            'taxes' => TaxResource::collection($this->taxes),

        ];
    }
}
