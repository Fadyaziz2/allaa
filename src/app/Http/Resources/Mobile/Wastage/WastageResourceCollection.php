<?php

namespace App\Http\Resources\Mobile\Wastage;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class WastageResourceCollection extends ResourceCollection
{
    public function toArray(Request $request): array
    {
        return [
            'data' => $this->collection->map(fn($item) => [
                'id' => $item->id,
                'product_id' => $item->product_id,
                'product_name' => $item->product?->name,
                'category_name' => $item->product?->category?->name,
                'quantity' => abs((float)$item->quantity_change),
                'movement_date' => app_date_format($item->movement_date),
                'note' => $item->note,
            ]),
            'pagination' => [
                'next_page_url' => $this->nextPageUrl(),
            ]
        ];
    }
}
