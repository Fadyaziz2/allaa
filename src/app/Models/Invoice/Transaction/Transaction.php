<?php

namespace App\Models\Invoice\Transaction;

use App\Models\Core\BaseModel;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\PaymentMethod\PaymentMethod;
use App\Models\User;
use App\Services\Invoice\Customization\CustomizationService;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Transaction extends BaseModel
{

    protected $fillable = [
        'invoice_number',
        'invoice_full_number',
        'invoice_id',
        'customer_id',
        'payment_method_id',
        'received_on',
        'amount',
        'note',
        'token',
        'received_by',
    ];

    protected $casts = [
      'amount' => 'float',
    ];

    public function invoice(): BelongsTo
    {
        return $this->belongsTo(Invoice::class);
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'customer_id', 'id');
    }

    public function paymentMethod(): BelongsTo
    {
        return $this->belongsTo(PaymentMethod::class);
    }

    public static function boot(): void
    {
        parent::boot();
        if (!app()->runningInConsole()) {
            static::creating(function ($model) {
                $invoiceSetting = resolve(CustomizationService::class)->index('payment');
                return $model->fill([
                    'invoice_number' => $model->max('invoice_number') + 1,
                    'invoice_full_number' => $invoiceSetting['payment_prefix'] . ($invoiceSetting['payment_serial_start'] + $model->max('invoice_number') + 1),
                ]);
            });
        }
    }
}
