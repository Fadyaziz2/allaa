<?php

namespace App\Http\Resources\Mobile\Customer;

use App\Http\Resources\Mobile\Status\StatusResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class CustomerInvoiceResourceCollection extends ResourceCollection
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
                    'invoice_number' => $item->invoice_full_number,
                    'issue_date' => app_date_format($item->issue_date),
                    'due_date' => app_date_format($item->due_date),
                    'total_amount' => number_with_currency_symbol($item->grand_total),
                    'paid_amount' => number_with_currency_symbol($item->received_amount),
                    'due_amount' => number_with_currency_symbol($item->due_amount),
                    'status' => StatusResource::make($item->status)
                ];

            }),
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
