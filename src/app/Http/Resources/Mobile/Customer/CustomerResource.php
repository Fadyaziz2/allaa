<?php

namespace App\Http\Resources\Mobile\Customer;

use App\Http\Resources\Mobile\Comman\Traits\ProfilePictureTraitResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CustomerResource extends JsonResource
{
    use ProfilePictureTraitResource;
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'full_name' => $this->full_name,
            'email' => $this->email,
            'profile_picture' => $this->profilePicture ? $this->customerProfilePicture($this->profilePicture->path) : null,
        ];
    }
}
