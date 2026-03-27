<?php

namespace App\Models\Invoice\Unit;

use App\Models\Core\BaseModel;
use App\Models\Invoice\Product\Product;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class Unit extends BaseModel
{
    use HasFactory;

    protected $fillable = ['name', 'short_name'];

    public function products(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Product::class);
    }
}
