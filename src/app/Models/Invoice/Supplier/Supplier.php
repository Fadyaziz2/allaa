<?php

namespace App\Models\Invoice\Supplier;

use App\Models\Core\BaseModel;
use App\Models\Invoice\Purchase\PurchaseInvoice;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Supplier extends BaseModel
{
    protected $fillable = ['name', 'email', 'phone', 'address', 'contact_person', 'note'];

    public function purchaseInvoices(): HasMany
    {
        return $this->hasMany(PurchaseInvoice::class);
    }

    public function getTotalPurchasedAttribute(): float
    {
        return (float)$this->purchaseInvoices()->sum('total');
    }

    public function getTotalPaidAttribute(): float
    {
        return (float)$this->purchaseInvoices()->sum('paid_amount');
    }

    public function getTotalDueAttribute(): float
    {
        return round($this->total_purchased - $this->total_paid, 2);
    }
}
