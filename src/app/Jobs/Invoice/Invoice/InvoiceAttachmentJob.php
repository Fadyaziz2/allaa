<?php

namespace App\Jobs\Invoice\Invoice;

use App\Mail\Invoice\Invoice\InvoiceAttachmentMail;
use App\Models\Invoice\Invoice\Invoice;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Storage;

class InvoiceAttachmentJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;


    public function __construct(public Invoice $invoice, public ?string $paymentReceived =  null)
    {
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        Mail::to(optional($this->invoice->customer)->email)
            ->send(
                (new InvoiceAttachmentMail($this->invoice, $this->paymentReceived)));

        Storage::delete('public/pdf/invoice_' . $this->invoice->invoice_full_number . '.pdf');
    }
}
