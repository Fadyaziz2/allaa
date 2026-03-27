<?php

namespace App\Mail\Tags;

use App\Helpers\Core\Notification\TagHelper;
use App\Models\User;

class UserInvitationTag extends TagHelper
{
    public function __construct(private readonly User $user)
    {

    }

    function tag(): array
    {
        return array_merge($this->common(), [
            '{receiver_name}' => $this->user->full_name,
            '{action_by}' => optional(auth()->user())->full_name,
            '{button_url}' => env('APP_URL') . "/user-join?token={$this->user->invitation_token}"
        ]);
    }
}
