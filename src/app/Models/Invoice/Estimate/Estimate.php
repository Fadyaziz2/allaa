<?php

namespace App\Models\Invoice\Estimate;

use App\Models\Core\BaseModel;
use App\Models\Core\Traits\Relationship\CreatedByRelationTrait;
use App\Models\Core\Traits\Relationship\StatusRelationTrait;
use App\Models\User;
use App\Services\Invoice\Customization\CustomizationService;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Estimate extends BaseModel
{
    use HasFactory, CreatedByRelationTrait, StatusRelationTrait;

    protected $fillable = [
        'customer_id',
        'date',
        'invoice_number',
        'invoice_full_number',
        'status_id',
        'sub_total',
        'discount_type',
        'discount_amount',
        'total_amount',
        'grand_total',
        'note',
        'estimate_template',
        'created_by',
    ];
    protected $casts = [
        'estimate_template' => 'integer',
        'status_id' => 'integer',
        'customer_id' => 'integer',
        'sub_total' => 'float',
        'discount_amount' => 'float',
        'total_amount' => 'float',
        'grand_total' => 'float',
    ];

    public function estimateDetails(): HasMany
    {
        return $this->hasMany(EstimateDetail::class, 'estimate_id', 'id');
    }

    public function taxes(): HasMany
    {
        return $this->hasMany(EstimateTax::class);
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'customer_id', 'id');
    }

    public static function boot()
    {
        parent::boot();
        if (!app()->runningInConsole()) {
            static::creating(function ($model) {
                $invoiceSetting = resolve(CustomizationService::class)->index('estimate');
                return $model->fill([
                    'invoice_number' => $model->max('invoice_number') + 1,
                    'invoice_full_number' => $invoiceSetting['estimate_prefix'] . ($invoiceSetting['estimate_serial_start'] + $model->max('invoice_number') + 1),
                    'created_by' => $model->created_by ?: auth()->id()

                ]);
            });
        }
    }
}
