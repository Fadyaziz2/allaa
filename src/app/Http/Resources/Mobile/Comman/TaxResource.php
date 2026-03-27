<?php

namespace App\Http\Resources\Mobile\Comman;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TaxResource extends JsonResource
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
            'tax_id' => $this->tax_id,
            'name' => $this->tax?->name,
            'rate' => $this->tax?->rate
        ];
    }
}
