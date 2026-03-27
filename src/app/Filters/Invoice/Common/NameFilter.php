<?php

namespace App\Filters\Invoice\Common;

use App\Filters\BaseFilter;
use Illuminate\Database\Eloquent\Builder;

class NameFilter extends BaseFilter
{
    public function search($search = null)
    {
        $this->builder->when($search, fn(Builder $builder) => $builder->where('name', 'LIKE', "%$search%"));
    }
}
