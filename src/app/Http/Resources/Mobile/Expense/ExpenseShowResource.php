<?php

namespace App\Http\Resources\Mobile\Expense;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ExpenseShowResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'date' => $this->date,
            'reference' => $this->reference,
            'amount' => $this->amount,
            'category_id' => $this->category_id,
            'note' => $this->note,
            'attachments' => $this->attachments
        ];
    }
}
