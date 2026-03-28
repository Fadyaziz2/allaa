<?php

namespace App\Models\Invoice\Purchase;

use App\Models\Core\BaseModel;
use App\Models\Invoice\Product\Product;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PurchaseInvoiceItem extends BaseModel
{
    protected $fillable = ['purchase_invoice_id', 'product_id', 'quantity', 'unit_price', 'line_total'];

    protected $casts = [
        'purchase_invoice_id' => 'int',
        'product_id' => 'int',
        'quantity' => 'double',
        'unit_price' => 'double',
        'line_total' => 'double',
    ];

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}
