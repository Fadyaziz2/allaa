<?php

namespace App\Filters\Core\Traits;

use Illuminate\Database\Eloquent\Builder;

trait NameFilterTrait
{
    public function search($search = null)
    {
        return $this->builder->when($search, fn (Builder $builder) => $builder->where('name', 'LIKE', "%$search%"));
    }
}
