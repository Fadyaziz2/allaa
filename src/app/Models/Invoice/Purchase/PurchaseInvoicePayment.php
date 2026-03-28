<?php

namespace App\Models\Invoice\Purchase;

use App\Models\Core\BaseModel;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PurchaseInvoicePayment extends BaseModel
{
    protected $fillable = ['purchase_invoice_id', 'amount', 'payment_date', 'reference', 'note'];

    protected $casts = [
        'purchase_invoice_id' => 'int',
        'amount' => 'double',
        'payment_date' => 'date',
    ];

    public function purchaseInvoice(): BelongsTo
    {
        return $this->belongsTo(PurchaseInvoice::class);
    }
}
