<?php

namespace App\Http\Resources\Mobile\Estimate;

use App\Http\Resources\Mobile\Status\StatusResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class EstimateResourceCollection extends ResourceCollection
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
                'customer_name' => $data->customer?->full_name,
                'invoice_full_number' => $data->invoice_full_number,
                'date' => app_date_format($data->date),
                'total' => number_with_currency_symbol($data->grand_total),
                'status' => StatusResource::make($data->status)
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
