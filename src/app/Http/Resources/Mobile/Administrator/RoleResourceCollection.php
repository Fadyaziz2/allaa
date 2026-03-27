<?php

namespace App\Http\Resources\Mobile\Administrator;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class RoleResourceCollection extends ResourceCollection
{
    public function toArray(Request $request): array
    {
        return [
            'data' => $this->collection->map(fn($data) => [
                'id' => $data->id,
                'name' => $data->name,
                'user_count' => $data->users_count > 1 ? intval($data->users_count) - 1 : intval($data->users_count),
                // Include profile pictures
                'user_profile_pictures' => $data->users->map(fn($user) => $user->profilePicture->full_path ?? null)->filter()->values()
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
