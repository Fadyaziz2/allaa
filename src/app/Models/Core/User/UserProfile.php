<?php

namespace App\Models\Core\User;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'gender', 'phone_number', 'phone_country', 'address', 'date_of_birth', 'tax_no' , 'portal_access'
    ];

    protected $casts = [
      'portal_access' => 'boolean',
      'user_id' => 'integer'
    ];
}
