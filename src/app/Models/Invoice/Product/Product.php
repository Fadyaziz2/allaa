<?php

namespace App\Models\Invoice\Product;

use App\Models\Core\BaseModel;
use App\Models\Invoice\Category\Category;
use App\Models\Invoice\Unit\Unit;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Product extends BaseModel
{
    use HasFactory;

    protected $fillable = [
        'name',
        'price',
        'opening_quantity',
        'current_quantity',
        'alert_quantity',
        'last_purchase_price',
        'code',
        'sku',
        'unit_id',
        'category_id',
        'description'
    ];

    protected $casts = [
      'unit_id' => 'int',
      'category_id' => 'int',
      'price' => 'double',
      'opening_quantity' => 'double',
      'current_quantity' => 'double',
      'alert_quantity' => 'double',
      'last_purchase_price' => 'double',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function unit(): BelongsTo
    {
        return $this->belongsTo(Unit::class);
    }

    public function stockMovements(): HasMany
    {
        return $this->hasMany(ProductStockMovement::class);
    }
}
