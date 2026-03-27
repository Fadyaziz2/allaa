<?php

namespace App\Http\Resources\Mobile\Customer;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CustomerShowResource extends JsonResource
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
            'first_name' => $this->first_name,
            'last_name' => $this->last_name,
            'email' => $this->email,
            'phone_number' => $this->userProfile?->phone_number,
            'phone_country' => $this->userProfile?->phone_country,
            'tax_no' => $this->userProfile?->tax_no,
            'portal_access' => $this->userProfile ? $this->userProfile->portal_access : false,
        ];
    }
}
