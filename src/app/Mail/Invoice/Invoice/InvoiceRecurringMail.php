<?php

namespace App\Mail\Invoice\Invoice;

use App\Helpers\Core\Notification\NotificationHelper;
use App\Mail\Tags\Invoice\InvoiceTag;
use App\Models\Invoice\Invoice\Invoice;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class InvoiceRecurringMail extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     */
    public function __construct(public Invoice $invoice)
    {
        //
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        $template = $this->template();

        return new Envelope(
            subject: $template->subjectReplace(['{invoice_number}' => $this->invoice->invoice_full_number, '{due_date}' => $this->invoice->due_date]),
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        $tags = new InvoiceTag($this->invoice);
        $template = $this->template();
        return new Content(
            view: 'templates.template',
            with: ['template' => $template->parse($tags->tag())]
        );
    }

    public function attachments(): array
    {
        return [
            Attachment::fromPath(storage_path('app/public/pdf/recurring_invoice_' . $this->invoice->invoice_full_number . '.pdf'))
                ->as("{$this->invoice->invoice_full_number}.pdf")
                ->withMime('application/pdf')
        ];
    }

    public function template()
    {
        return NotificationHelper::new()
            ->on('recurring_sending_attachment')
            ->mail();
    }
}
