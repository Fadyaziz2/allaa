<?php

namespace App\Http\Resources\Mobile\Category;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class CategoryResourceCollection extends ResourceCollection
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
                'type' => $data->type,
                'total_products' => $data->total_products ?? 0,
                'total_expenses' => $data->total_expenses ?? 0,
                'can_edit' => true,
                'can_delete' => (($data->total_products ?? 0) === 0) && (($data->total_expenses ?? 0) === 0),
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
