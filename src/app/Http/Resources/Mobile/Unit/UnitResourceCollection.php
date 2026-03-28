<?php

namespace App\Http\Resources\Mobile\Unit;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class UnitResourceCollection extends ResourceCollection
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
                'name' => $data->name,
                'short_name' => $data->short_name,
                'total_products' => $data->total_products ?? 0,
                'can_edit' => true,
                'can_delete' => ($data->total_products ?? 0) === 0,
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
