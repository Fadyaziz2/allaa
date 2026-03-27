<?php

namespace App\Models\Invoice\Tax;

use App\Models\Core\BaseModel;

class Tax extends BaseModel
{
    protected $fillable = [
        'name', 'rate'
    ];

    protected $casts = [
        'rate' => 'float',
    ];
}
