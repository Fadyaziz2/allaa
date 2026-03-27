<?php

namespace App\Mail\Core\User;

use App\Helpers\Core\Notification\NotificationHelper;
use App\Mail\Tags\ForgetPasswordTag;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class ForgetPasswordMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     */
    public function __construct(protected $user, protected string $token)
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
        $tags = new ForgetPasswordTag($this->user, $this->token);
        $template = $this->template();
        return new Content(
            view: 'templates.template',
            with: ['template' => $template->parse($tags->tag())]
        );
    }

    public function template()
    {
        return NotificationHelper::new()
            ->on('reset_password')
            ->mail();
    }
}
