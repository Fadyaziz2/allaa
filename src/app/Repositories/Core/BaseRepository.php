<?php

namespace App\Repositories\Core;

use Illuminate\Database\Eloquent\Model;

class BaseRepository
{
    /**
     *  Repository model.
     * @khokon ahmed
     *
     * @var Model
     */
    protected Model $model;


    public function __call($name, $arguments)
    {
        return $this->model->{$name}(...$arguments);
    }
}
