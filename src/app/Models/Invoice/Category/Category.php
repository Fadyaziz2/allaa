<?php

namespace App\Models\Invoice\Category;

use App\Models\Core\BaseModel;
use App\Models\Invoice\Product\Product;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Category extends BaseModel
{
    use HasFactory;

    protected $fillable = ['name', 'type'];

    public function products(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Product::class);
    }
}
