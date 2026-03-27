<?php

namespace App\Http\Resources\Mobile\Estimate;

use App\Http\Resources\Mobile\Comman\CustomerResource;
use App\Http\Resources\Mobile\Comman\ItemDetailResource;
use App\Http\Resources\Mobile\Comman\TaxResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class EstimateShowResource extends JsonResource
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
            'customer_id' => $this->customer_id,
            'date' => $this->date,
            'estimate_template' => $this->estimate_template,
            'estimate_details' => ItemDetailResource::collection($this->estimateDetails),
            'taxes' => TaxResource::collection($this->taxes),
            'discount_type' => $this->discount_type,
            'discount_amount' => $this->discount_amount,
            'note' => $this->note,
        ];
    }
}
