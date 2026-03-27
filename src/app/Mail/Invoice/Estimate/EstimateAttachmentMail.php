<?php

namespace App\Mail\Invoice\Estimate;

use App\Helpers\Core\Notification\NotificationHelper;
use App\Mail\Tags\Invoice\EstimateTag;
use App\Models\Invoice\Estimate\Estimate;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class EstimateAttachmentMail extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     */
    public function __construct(public Estimate $estimate)
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
            subject: $template->subjectReplace(['{app_name}' => config('app.name')]),
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        $tags = new EstimateTag($this->estimate);
        $template = $this->template();
        return new Content(
            view: 'templates.template',
            with: ['template' => $template->parse($tags->tag())]

        );
    }

    public function attachments(): array
    {
        return [
            Attachment::fromPath(storage_path('app/public/pdf/estimate_' . $this->estimate->invoice_full_number . '.pdf'))
                ->as("{$this->estimate->invoice_full_number}.pdf")
                ->withMime('application/pdf')
        ];
    }

    public function template()
    {
        return NotificationHelper::new()
            ->on('quotation_sending_attachment')
            ->mail();
    }
}
