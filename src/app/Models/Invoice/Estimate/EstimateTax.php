<?php

namespace App\Models\Invoice\Estimate;

use App\Models\Invoice\Tax\Tax;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EstimateTax extends Model
{
    use HasFactory;

    protected $fillable = [
        'tax_id',
        'estimate_id',
        'total_amount',
    ];

    public function tax()
    {
        return $this->belongsTo(Tax::class);
    }
}
