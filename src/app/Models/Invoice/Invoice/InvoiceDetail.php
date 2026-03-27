<?php

namespace App\Models\Invoice\Invoice;

use App\Models\Invoice\Product\Product;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class InvoiceDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'quantity',
        'price',
        'invoice_id',
        'product_id'
    ];

    protected $casts = [
        'product_id' => 'integer',
        'invoice_id' => 'integer',
        'quantity' => 'integer',
        'price' => 'float',
    ];


    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class, 'product_id', 'id');
    }
}
