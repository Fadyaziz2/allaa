<?php

namespace App\Notifications\Core\User;

use App\Helpers\Core\Notification\NotificationHelper;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class UserJoinNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(public $templates, public User $user)
    {

    }

    public function via(object $notifiable): array
    {
        return ['mail', 'database'];
    }

    public function toMail($notifiable): MailMessage
    {

        return (new MailMessage)
            ->subject(optional($this->template()->mail())->subjectReplace([
                '{app_name}' => config('settings.application.company_name')
            ]))
            ->view('templates.template', ['template' => optional($this->template()->mail())->parse([
                '{name}' => $this->user->full_name,
                '{app_name}' => config('app.name'),
                '{company_name}' => config('app.name'),
                '{app_logo}' => asset(config('settings.application.company_logo')),
                '{receiver_name}' => $this->user->full_name,
            ])]);
    }

    public function toArray($notifiable): array
    {
        return [
            'message' => optional($this->template()->database())->parse([
                '{app_name}' => config('settings.application.company_name'),
            ])
        ];
    }

    public function template(): NotificationHelper
    {
        return new NotificationHelper($this->templates);
    }
}
