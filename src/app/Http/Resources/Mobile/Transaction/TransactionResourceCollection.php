<?php

namespace App\Http\Resources\Mobile\Transaction;

use App\Http\Resources\Mobile\Comman\Traits\ProfilePictureTraitResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class TransactionResourceCollection extends ResourceCollection
{
    use ProfilePictureTraitResource;
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
                'received_on' => app_date_format($data->received_on),
                'invoice_full_number' => $data->invoice?->invoice_full_number,
                'transaction_full_number' => $data->invoice_full_number,
                'payment_method' => $data->paymentMethod?->name,
                'amount' => number_with_currency_symbol($data->amount),
                'note' => $data->note,
                'profile_picture' => $data->customer?->profilePicture ? $this->customerProfilePicture($data->customer->profilePicture->path) : null,
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
