<?php

namespace App\Models\Invoice\Product;

use App\Models\Core\BaseModel;
use App\Models\Invoice\Category\Category;
use App\Models\Invoice\Unit\Unit;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Product extends BaseModel
{
    use HasFactory;

    protected $fillable = [
        'name',
        'price',
        'code',
        'unit_id',
        'category_id',
        'description'
    ];

    protected $casts = [
      'unit_id' => 'int',
      'category_id' => 'int',
      'price' => 'double'
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function unit(): BelongsTo
    {
        return $this->belongsTo(Unit::class);
    }
}
