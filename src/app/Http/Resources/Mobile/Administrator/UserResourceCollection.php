<?php

namespace App\Http\Resources\Mobile\Administrator;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class UserResourceCollection extends ResourceCollection
{
    public function toArray(Request $request): array
    {

        return [
            'data' => $this->collection->map(fn($data) => [
                'id' => $data->id,
                'full_name' => $data->full_name,
                'email' => $data->email,
                'is_admin' => $data->is_admin,
                'status_class' => @$data->status->class,
                'status_name' => @$data->status->name,
                'status' => @$data->status->translated_name,
                'role' => @$data->role->name,
                'profile_pictures' => $data->profilePicture->full_path ?? null
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
            ]
        ];
    }
}
