<?php

namespace App\Http\Resources\Mobile\PaymentMethod;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PaymentMethodShowResource extends JsonResource
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
            'name' => $this->name,
            'type' => $this->type,
            'settings' => $this->settings($this->settings)
        ];
    }

    public function settings($settings)
    {
        return $settings->map(function ($setting) {
            return [
                'api_key' => $setting->name,
                'api_secret' => $setting->value
            ];
        });
    }
}
