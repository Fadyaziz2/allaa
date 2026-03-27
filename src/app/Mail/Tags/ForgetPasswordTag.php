<?php

namespace App\Mail\Tags;

use App\Helpers\Core\Notification\TagHelper;

class ForgetPasswordTag extends TagHelper
{
    public function __construct(protected $user, protected $token)
    {

    }

    function tag(): array
    {
        return array_merge($this->common(), [
            '{receiver_name}' => $this->user->full_name,
            '{button_url}' => env('APP_URL') . "/confirm-password?token=" . $this->token
        ]);
    }
}
