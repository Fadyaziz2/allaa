<?php

namespace App\Models\Invoice\Estimate;

use App\Models\Invoice\Product\Product;
use Illuminate\Database\Eloquent\Model;

class EstimateDetail extends Model
{

    protected $fillable = [
        'quantity',
        'price',
        'estimate_id',
        'product_id'
    ];

    protected $casts = [
        'product_id' => 'integer',
        'estimate_id' => 'integer',
        'quantity' => 'integer',
        'price' => 'float',
    ];

    public function product(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Product::class, 'product_id', 'id');
    }
}
