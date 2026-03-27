<?php

namespace App\Jobs\Invoice\Invoice;

use App\Models\Invoice\Invoice\Invoice;
use App\Services\Invoice\Invoice\InvoiceService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Storage;

class InvoiceRecurringJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     */
    public InvoiceService $service;

    public function __construct(public Invoice $invoice)
    {
        $this->service = new InvoiceService($invoice);
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        $invoiceInfo = $this->service->setModel($this->invoice)->loadInvoiceInfo();
        $this->service
            ->setAttribute('file_path', 'public/pdf/recurring_invoice_' . $this->invoice->invoice_full_number . '.pdf')
            ->pdfGenerate($invoiceInfo)
            ->sendRecurringAttachmentMail($this->invoice);

        Storage::delete('public/pdf/recurring_invoice_' . $this->invoice->invoice_full_number . '.pdf');
    }
}
