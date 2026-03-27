<?php

namespace App\Mail\Tags\Invoice;

use App\Helpers\Core\Notification\TagHelper;
use App\Models\User;

class CustomerPortalAccessTag extends TagHelper
{
    public string $password;

    public function __construct(private readonly User $user, $password)
    {
        $this->password = $password;
    }

    function tag(): array
    {
        return array_merge($this->common(), [
            '{receiver_name}' => $this->user->full_name,
            '{email}' => $this->user->email,
            '{password}' => $this->password,
            '{button_url}' => env('APP_URL')
        ]);
    }
}
