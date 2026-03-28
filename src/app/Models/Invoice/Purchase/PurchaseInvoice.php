<?php

namespace App\Models\Invoice\Purchase;

use App\Models\Core\BaseModel;
use App\Models\Invoice\Supplier\Supplier;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class PurchaseInvoice extends BaseModel
{
    protected $fillable = [
        'supplier_id','invoice_number','invoice_date','sub_total','discount','tax','total','paid_amount','note'
    ];

    protected $casts = [
        'supplier_id' => 'int',
        'invoice_date' => 'date',
        'sub_total' => 'double',
        'discount' => 'double',
        'tax' => 'double',
        'total' => 'double',
        'paid_amount' => 'double',
    ];

    protected $appends = ['due_amount'];

    public function supplier(): BelongsTo
    {
        return $this->belongsTo(Supplier::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(PurchaseInvoiceItem::class);
    }

    public function payments(): HasMany
    {
        return $this->hasMany(PurchaseInvoicePayment::class);
    }

    public function getDueAmountAttribute(): float
    {
        return round((float)$this->total - (float)$this->paid_amount, 2);
    }
}
