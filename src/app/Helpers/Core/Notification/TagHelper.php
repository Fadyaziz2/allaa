<?php

namespace App\Helpers\Core\Notification;

abstract class TagHelper
{
    abstract function tag();

    public function common(): array
    {
        return [
            '{app_name}' => config('app.name'),
            '{app_logo}' => env('APP_URL') . config('settings.application.company_logo')
        ];

    }

}
