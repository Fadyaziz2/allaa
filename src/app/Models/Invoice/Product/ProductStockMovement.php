<?php

namespace App\Models\Invoice\Product;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductStockMovement extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_id',
        'type',
        'quantity_change',
        'quantity_after',
        'unit_price',
        'reference_type',
        'reference_id',
        'note',
        'movement_date',
    ];

    protected $casts = [
        'product_id' => 'int',
        'quantity_change' => 'double',
        'quantity_after' => 'double',
        'unit_price' => 'double',
        'reference_id' => 'int',
        'movement_date' => 'datetime',
    ];

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}
