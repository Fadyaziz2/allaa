<?php

namespace App\Filters\Invoice\Expense;

use Carbon\Carbon;
use App\Filters\BaseFilter;
use Illuminate\Database\Eloquent\Builder;
use App\Filters\Invoice\Traits\CategoryFilterTrait;

class ExpenseFilter extends BaseFilter
{
    use CategoryFilterTrait;

    public function search($search = null): void
    {
        $this->builder->when($search, fn(Builder $builder) => $builder->where('title', 'LIKE', "%$search%"));
    }

    public function date($range = null): void
    {
        if ($range){
            $startDate = $range[0];
            $endDate = $range[1];
            $this->builder->when($startDate && $endDate, fn(Builder $q) => $q->whereBetween('date', [$startDate, $endDate]));
        }
    }

}
