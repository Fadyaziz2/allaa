<?php

namespace App\Models\Invoice\Invoice;

use App\Models\Core\BaseModel;
use App\Models\Core\Traits\Relationship\CreatedByRelationTrait;
use App\Models\Core\Traits\Relationship\StatusRelationTrait;
use App\Models\Invoice\Recurring\RecurringType;
use App\Models\User;
use App\Services\Invoice\Customization\CustomizationService;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Invoice extends BaseModel
{
    use HasFactory, CreatedByRelationTrait, StatusRelationTrait;

    protected $fillable = [
        'customer_id',
        'issue_date',
        'due_date',
        'invoice_number',
        'invoice_full_number',
        'reference_number',
        'recurring',
        'recurring_type_id',
        'status_id',
        'sub_total',
        'discount_type',
        'discount_amount',
        'total_amount',
        'grand_total',
        'received_amount',
        'due_amount',
        'note',
        'invoice_template',
        'created_by'
    ];

    protected $casts = [
        'customer_id' => 'integer',
        'status_id' => 'integer',
        'invoice_template' => 'integer',
        'recurring_type_id' => 'integer',
        'total_amount' => 'float',
        'grand_total' => 'float',
        'received_amount' => 'float',
        'due_amount' => 'float',
        'sub_total' => 'float',
        'discount_amount' => 'float',
    ];


    public static function boot()
    {
        parent::boot();
        if (!app()->runningInConsole()) {
            static::creating(function ($model) {
                $invoiceSetting = resolve(CustomizationService::class)->index('invoice');
                return $model->fill([
                    'invoice_number' => $model->max('invoice_number') + 1,
                    'invoice_full_number' => $invoiceSetting['invoice_prefix'] . ($invoiceSetting['invoice_serial_start'] + $model->max('invoice_number') + 1),
                    'created_by' => $model->created_by ?: auth()->id()

                ]);
            });
        }
    }


    public function recurringType(): BelongsTo
    {
        return $this->belongsTo(RecurringType::class, 'recurring_type_id', 'id');
    }

    public function invoiceDetails(): HasMany
    {
        return $this->hasMany(InvoiceDetail::class, 'invoice_id', 'id');
    }

    public function taxes(): HasMany
    {
        return $this->hasMany(InvoiceTax::class);
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'customer_id', 'id');
    }

    public function recurrings(): HasMany
    {
        return $this->hasMany(InvoiceRecurring::class, 'reference_invoice_id', 'id');
    }
}
