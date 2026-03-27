<?php

namespace App\Models\Invoice\Invoice;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InvoiceRecurring extends Model
{
    use HasFactory;

   protected $fillable = [
        'invoice_id', 'reference_invoice_id', 'recurring_date'
   ];
}
