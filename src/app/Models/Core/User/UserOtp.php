<?php

namespace App\Models\Core\User;

use Illuminate\Database\Eloquent\Model;

class UserOtp extends Model
{
    protected $fillable = [
        'user_id',
        'otp',
        'expire_at',
    ];

    protected $casts = [
        'user_id' => 'integer',
    ];
}
