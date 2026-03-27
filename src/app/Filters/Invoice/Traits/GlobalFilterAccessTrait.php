<?php

namespace App\Filters\Invoice\Traits;

use Illuminate\Database\Eloquent\Builder;

trait GlobalFilterAccessTrait
{
    public function globalRoleAccess($value = 'no')
    {
        $user = auth()->user();

        return $this->builder->when($user->isCustomer(), fn(Builder $builder) => $builder->where('customer_id', $user->id));
    }

}
