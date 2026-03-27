<?php

namespace App\Mail\Tags\Invoice;

use App\Helpers\Core\Notification\TagHelper;
use App\Models\Invoice\Estimate\Estimate;

class EstimateTag extends TagHelper
{
    public function __construct(protected Estimate $estimate)
    {

    }

    function tag(): array
    {
        return array_merge($this->common(), [
            '{receiver_name}' => optional($this->estimate->customer)->full_name,
            '{quotation_number}' => $this->estimate->invoice_full_number
        ]);
    }
}
