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

class InvoiceAttachmentMail extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     */
    public function __construct(public Invoice $invoice, public ?string $paymentReceived = null)
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

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        return [
            Attachment::fromPath(storage_path('app/public/pdf/invoice_' . $this->invoice->invoice_full_number . '.pdf'))
                ->as("{$this->invoice->invoice_full_number}.pdf")
                ->withMime('application/pdf')
        ];
    }

    public function template()
    {
        $event = $this->paymentReceived ? 'payment_received' : 'invoice_sending_attachment';
        return NotificationHelper::new()
            ->on($event)
            ->mail();
    }
}
