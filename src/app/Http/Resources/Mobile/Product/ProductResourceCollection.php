<?php

namespace App\Http\Resources\Mobile\Product;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class ProductResourceCollection extends ResourceCollection
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
                'sku' => $data->sku ?: $data->code,
                'code' => $data->sku ?: $data->code,
                'category_name' => $data->category?->name,
                'price' => number_with_currency_symbol($data->price),
                'current_quantity' => (float)$data->current_quantity,
                'alert_quantity' => (float)$data->alert_quantity,
                'last_purchase_price' => $data->last_purchase_price
                    ? number_with_currency_symbol($data->last_purchase_price)
                    : null,
                'is_low_stock' => (float)$data->current_quantity <= (float)$data->alert_quantity
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
