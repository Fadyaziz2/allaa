<?php

namespace App\Filters\Core\User;

use App\Filters\BaseFilter;
use Illuminate\Database\Eloquent\Builder;

class UserFilter extends BaseFilter
{
    public function search($search = null)
    {
        return $this->builder->when($search, function (Builder $builder) use ($search) {
            $builder->where('first_name', 'LIKE', "%$search%")
                ->orWhere('last_name', 'LIKE', "%{$search}%")
                ->orWhere('email', 'LIKE', "%$search%")
                ->orWhereRaw("CONCAT(first_name, ' ', last_name) LIKE ?", ['%' . $search . '%']);
        });
    }

    public function status($id = null): void
    {
        $this->builder->when($id, fn(Builder $query) => $query->whereHas('status', fn(Builder $query) => $query->where('status_id', $id)));
    }

    public function role($id = null): void
    {
        $this->builder->when($id, fn(Builder $query) => $query->whereHas('roles', fn(Builder $query) => $query->where('role_id', $id)));
    }
}
