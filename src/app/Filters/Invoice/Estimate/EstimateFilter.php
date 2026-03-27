<?php

namespace App\Filters\Invoice\Estimate;

use Carbon\Carbon;
use App\Filters\BaseFilter;
use Illuminate\Database\Eloquent\Builder;
use App\Filters\Invoice\Traits\CustomerFilterTrait;
use App\Filters\Invoice\Traits\GlobalFilterAccessTrait;

class EstimateFilter extends BaseFilter
{
    use CustomerFilterTrait, GlobalFilterAccessTrait;

    public function search($search = null): void
    {
        $this->builder->when($search, fn(Builder $builder) => $builder->where('invoice_full_number', 'LIKE', "%$search%"));
    }

    public function status($ids = null): void
    {
        $this->builder->when($ids, fn(Builder $query) => $query->whereHas('status', fn(Builder $query) => $query->whereIn('status_id', explode(',', $ids))));
    }

    public function date($range = null): void
    {
        $startDate = $range[0];
        $endDate = $range[1];

        $this->builder->when($startDate && $endDate, fn(Builder $q) => $q->whereBetween('date', [$startDate, $endDate]));
    }

}
