<?php

namespace App\Models\Invoice\Expense;

use App\Models\Core\BaseModel;
use App\Models\Core\File\File;
use App\Models\Invoice\Category\Category;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;


class Expense extends BaseModel
{
    use HasFactory;

    protected $fillable = [
        'title',
        'date',
        'reference',
        'amount',
        'category_id',
        'note'
    ];

    protected $casts = [
        'amount' => 'float',
        'category_id' => 'integer'
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class, 'category_id', 'id');
    }

    protected function date(): Attribute
    {
        return Attribute::make(
            set: fn(string $value) => Carbon::create($value)->format("Y-m-d"),
        );
    }

    public function attachments(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(File::class, 'imageable');
    }
}
