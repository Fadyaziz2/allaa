<?php

namespace App\Models\Invoice\Invoice;

use App\Models\Invoice\Tax\Tax;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InvoiceTax extends Model
{
    use HasFactory;

    protected $fillable = [
        'tax_id',
        'invoice_id',
        'total_amount',
    ];

    protected $casts = [
        'tax_id' => 'integer',
        'invoice_id' => 'integer',
        'total_amount' => 'float',
    ];

    public function tax(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Tax::class);
    }
}
