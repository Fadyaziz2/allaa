<?php

namespace App\Models\Invoice\Recurring;

use Illuminate\Database\Eloquent\Model;

class RecurringType extends Model
{

    protected $fillable = ['name'];

    protected $appends = ['original_name'];

    public function getOriginalNameAttribute(): array|string
    {
        return str_replace('_', ' ', ucfirst($this->attributes['name']));
    }
}
