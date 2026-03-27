<?php

namespace App\Filters\Invoice\Traits;

use Illuminate\Database\Eloquent\Builder;

trait CategoryFilterTrait
{
    public function category($ids = null): void
    {
        $category = explode(',', $ids);

        $this->builder->when($ids, fn(Builder $query) => $query->whereHas('category', fn(Builder $query) => $query->whereIn('category_id', $category)));
    }
}
