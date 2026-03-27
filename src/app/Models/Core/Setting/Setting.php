<?php

namespace App\Models\Core\Setting;

use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    protected $fillable = ['name', 'value', 'context', 'settingable_type', 'settingable_id'];

    public function settingable(): \Illuminate\Database\Eloquent\Relations\MorphTo
    {
        return $this->morphTo();
    }
}
