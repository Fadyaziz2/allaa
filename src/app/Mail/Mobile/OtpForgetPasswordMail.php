<?php

namespace App\Mail\Mobile;

use App\Helpers\Core\Notification\NotificationHelper;
use App\Mail\Tags\OtpForgetPasswordTag;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class OtpForgetPasswordMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     */
    public function __construct(protected $user, protected string $otpNumber)
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
            subject: $template->subjectReplace(['{app_name}' => config('settings.application.company_name')]),
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        $tags = new OtpForgetPasswordTag($this->user, $this->otpNumber);

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
        return [];
    }

    public function template()
    {
        return NotificationHelper::new()
            ->on('reset_password')
            ->mail();
    }
}
