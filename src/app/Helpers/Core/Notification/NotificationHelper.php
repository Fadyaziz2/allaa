<?php

namespace App\Helpers\Core\Notification;

use App\Helpers\Core\Traits\InstanceCreator;
use App\Models\Core\Notification\NotificationType;
use App\Models\User;
use Illuminate\Support\Facades\Notification;

class NotificationHelper
{
    use InstanceCreator;

    public string $event;

    protected mixed $templates;

    public $template;

    public array $notificationAudiences = [];

    protected array $data = [];

    public function __construct($templates = [])
    {
        $this->templates = $templates;
    }

    public function on($event): static
    {
        $this->event = $event;
        return $this;
    }

    public function sms()
    {
        return $this->finder('sms');
    }

    public function mail()
    {
        return $this->finder();
    }

    public function database()
    {
        return $this->finder('database');
    }


    protected function finder($template = 'mail')
    {
        return $this->template = collect($this->getTemplates())->first(function ($t) use ($template) {
            return $t->type == $template;
        });
    }

    public function audiences()
    {

        $notificationAudiences = [];
        foreach ($this->getTemplates() as $template) {

            if ($template->type == 'database') {
                foreach ($template->audiences as $audience) {
                    $audienceArray = json_decode($audience['audience'], true);
                    $notificationAudiences = $audienceArray;
                }
            }

        }

        return $notificationAudiences;

    }

    public function mergeAudiences($audiences): static
    {
        $newAudience = is_array($audiences) ? $audiences : func_get_args();
        $this->notificationAudiences = $newAudience;
        return $this;
    }


    public function with($body): static
    {
        $this->data = is_array($body) ? $body : func_get_args();
        return $this;
    }


    public function send($notification): void
    {
        $audiences = array_unique(array_merge($this->audiences(), $this->notificationAudiences));
        $users = User::query()->whereHas('roles', fn($query) => $query->whereIn('id', $audiences))->get();
        Notification::send($users, new $notification($this->getTemplates(), ...$this->data));
    }

    public function getTemplates()
    {
        if (count($this->templates)) {
            return $this->templates;
        }
        $event = NotificationType::query()
            ->with('notificationTemplates')
            ->where('name', $this->event)
            ->first();
        return $event->notificationTemplates;
    }


}
