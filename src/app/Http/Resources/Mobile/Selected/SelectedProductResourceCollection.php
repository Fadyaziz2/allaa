<?php

namespace App\Http\Resources\Mobile\Selected;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class SelectedProductResourceCollection extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @return array<int|string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'data' => $this->collection->map(function ($item) {
                return [
                    'id' => $item->id,
                    'name' => $item->name,
                    'price' => $item->price
                ];
            }),
//            'pagination' => [
//                'total' => $this->total(),
//                'count' => $this->count(),
//                'per_page' => $this->perPage(),
//                'current_page' => $this->currentPage(),
//                'total_pages' => $this->lastPage(),
//                'first_page_url' => $this->onFirstPage(),
//                'next_page_url' => $this->nextPageUrl(),
//                'prev_page_url' => $this->previousPageUrl(),
//            ]
        ];
    }
}
