<?php

namespace App\Mail\Tags;

use App\Helpers\Core\Notification\TagHelper;
use App\Models\User;

class OtpForgetPasswordTag extends TagHelper
{
    public function __construct(protected $user, protected string $otpNumber)
    {

    }

    function tag(): array
    {
        return array_merge($this->common(), [
            '{receiver_name}' => $this->user->full_name,
            '{otp_number}' => $this->otpNumber
        ]);
    }
}
