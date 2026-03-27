<?php

namespace App\Http\Resources\Mobile\Customer;

use App\Http\Resources\Mobile\Status\StatusResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class CustomerResourceCollection extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @return array<int|string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'data' => $this->collection->map(fn($data) => [
                'id' => $data->id,
                'full_name' => $data->full_name,
                'email' => $data->email,
                'status' => StatusResource::make($data->status),
                'profile_picture_url' => $data->profilePicture ? env('APP_URL') . $data->profilePicture->path : null,
            ]),

            'pagination' => [
                'total' => $this->total(),
                'count' => $this->count(),
                'per_page' => $this->perPage(),
                'current_page' => $this->currentPage(),
                'total_pages' => $this->lastPage(),
                'first_page_url' => $this->onFirstPage(),
                'next_page_url' => $this->nextPageUrl(),
                'prev_page_url' => $this->previousPageUrl(),
            ],

        ];
    }
}
