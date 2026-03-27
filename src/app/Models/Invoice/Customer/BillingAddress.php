<?php

namespace App\Models\Invoice\Customer;

use App\Models\Invoice\Country\Country;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;

class BillingAddress extends Model
{

    protected $fillable = [
        'user_id',
        'name',
        'country_id',
        'city',
        'state',
        'zip_code',
        'phone',
        'address'
    ];

    protected $casts = [
        'country_id' => 'integer'
    ];

    public function customer(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function country(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Country::class);
    }
}
