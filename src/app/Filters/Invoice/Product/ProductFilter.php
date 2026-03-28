<?php

namespace App\Filters\Invoice\Product;

use App\Filters\BaseFilter;
use App\Filters\Invoice\Traits\CategoryFilterTrait;
use Illuminate\Database\Eloquent\Builder;

class ProductFilter extends BaseFilter
{
    use CategoryFilterTrait;

    public function search($search = null): void
    {
        $this->builder->when($search, fn(Builder $builder) => $builder->where(function (Builder $query) use ($search) {
            $query->where('name', 'LIKE', "%$search%")
                ->orWhere('sku', 'LIKE', "%$search%")
                ->orWhere('code', 'LIKE', "%$search%");
        }));
    }

    public function unit($ids = null): void
    {
        $unit = explode(',', $ids);

        $this->builder->when($ids, fn(Builder $query) => $query->whereHas('unit', fn(Builder $query) => $query->whereIn('unit_id', $unit)));
    }

    public function brand($ids = null): void
    {
        $brand = explode(',', $ids);

        $this->builder->when($ids, fn(Builder $query) => $query->whereHas('brand', fn(Builder $query) => $query->whereIn('brand_id', $brand)));
    }
}
