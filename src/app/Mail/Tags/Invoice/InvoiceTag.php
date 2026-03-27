<?php

namespace App\Mail\Tags\Invoice;

use App\Helpers\Core\Notification\TagHelper;
use App\Models\Invoice\Invoice\Invoice;

class InvoiceTag extends TagHelper
{
    public function __construct(public Invoice $invoice)
    {
    }

    function tag(): array
    {
        return array_merge($this->common(), [
            '{receiver_name}' => optional($this->invoice->customer)->full_name,
            '{invoice_number}' => $this->invoice->invoice_full_number
        ]);
    }
}
