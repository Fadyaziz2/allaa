<?php

namespace App\Filters\Invoice\Transaction;

use Exception;
use Carbon\Carbon;
use App\Filters\BaseFilter;
use Illuminate\Database\Eloquent\Builder;
use App\Filters\Invoice\Traits\CustomerFilterTrait;
use App\Filters\Invoice\Traits\GlobalFilterAccessTrait;

class TransactionFilter extends BaseFilter
{
    use CustomerFilterTrait, GlobalFilterAccessTrait;

    public function search($search = null): void
    {
        $this->builder->when($search, fn(Builder $builder) => $builder->where('invoice_full_number', 'LIKE', "%$search%"));
    }

    public function paymentMethod($ids = null): void
    {
        $paymentMethodId = explode(',', $ids);

        $this->builder->when($ids, fn(Builder $query) => $query->whereHas('paymentMethod', fn(Builder $query) => $query->where('payment_method_id', $paymentMethodId)));
    }

    public function date($range = null): void
    {
        $startDate = $range[0];
        $endDate = $range[1];
        $this->builder->when($startDate && $endDate)->whereBetween('received_on', [$startDate, $endDate]);

    }
}
