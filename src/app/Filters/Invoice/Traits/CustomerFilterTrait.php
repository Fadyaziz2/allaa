<?php

namespace App\Filters\Invoice\Traits;

use Illuminate\Database\Eloquent\Builder;

trait CustomerFilterTrait
{
    public function customer($ids = null): void
    {
        $customer = explode(',', $ids);

        $this->builder->when($ids, fn(Builder $query) => $query->whereHas('customer', fn(Builder $query) => $query->where('customer_id', $customer)));
    }
}
