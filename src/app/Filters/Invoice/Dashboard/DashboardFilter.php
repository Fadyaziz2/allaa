<?php

namespace App\Filters\Invoice\Dashboard;

use App\Filters\BaseFilter;
use Illuminate\Support\Carbon;

class DashboardFilter extends BaseFilter
{
    public function week(): \Illuminate\Database\Eloquent\Builder
    {
        return $this->builder->whereBetween('issue_date',
            [
                Carbon::now()->startOfWeek()->format('Y-m-d'),
                Carbon::now()->endOfWeek()->format('Y-m-d')
            ]);
    }

    public function month(): \Illuminate\Database\Eloquent\Builder
    {
        return $this->builder->whereBetween('issue_date',
            [
                Carbon::now()->startOfMonth()->format('Y-m-d'),
                Carbon::now()->endOfMonth()->format('Y-m-d')
            ]);
    }

    public function year(): \Illuminate\Database\Eloquent\Builder
    {
        return $this->builder->whereBetween('issue_date',
            [
                Carbon::now()->startOfYear()->format('Y-m-d'),
                Carbon::now()->endOfYear()->format('Y-m-d')
            ]);
    }

    public function total()
    {

    }
}
