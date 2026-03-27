<?php

namespace App\Http\Resources\Invoice;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CustomerPaymentMethodCollection extends JsonResource
{
    /**
     * Transform the resource collection into an array.
     *
     * @return array<int|string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'type' => $this->type,
            'api_key' => $this->settings ? $this->settingsManipulation($this->settings) : null
        ];
    }

    private function settingsManipulation($settings)
    {
        return $settings->where('name', 'api_key')->first()->value ?? null;
    }
}
