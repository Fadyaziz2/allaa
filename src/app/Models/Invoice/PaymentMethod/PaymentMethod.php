<?php

namespace App\Models\Invoice\PaymentMethod;

use App\Models\Core\BaseModel;
use App\Models\Core\Setting\Setting;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class PaymentMethod extends BaseModel
{
    use HasFactory;

    protected $fillable = [
        'name', 'type'
    ];

    public function settings(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Setting::class, 'settingable');
    }
}
