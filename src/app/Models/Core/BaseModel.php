<?php

namespace App\Models\Core;

use App\Filters\BaseFilter;
use Illuminate\Database\Eloquent\Model;

class BaseModel extends Model
{

    public function scopeFilter($query, BaseFilter $filter): \Illuminate\Database\Eloquent\Builder
    {
        return $filter->apply($query);
    }

}
