<?php

namespace App\Mail\Tags;

use App\Helpers\Core\Notification\TagHelper;
use App\Models\User;

class UserJoinTag extends TagHelper
{
    public function __construct(public User $use)
    {

    }

    function tag(): array
    {
        return array_merge($this->common(), [
            '{receiver_name}' => $this->user->full_name,
        ]);
    }
}
