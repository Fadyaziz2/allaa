<?php

namespace App\Http\Resources\Mobile\Setting;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SettingResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'company' => [
                'company_name' => $this['company_name'],
                'company_logo' => $this['company_logo'],
                'company_icon' => $this['company_icon'],
                'company_banner' => $this['company_banner'],
            ],
            
            'permissions' => $this['permissions'],
        ];
    }
}
