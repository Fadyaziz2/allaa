<?php

namespace App\Services\Invoice;

use App\Services\BaseService;

class AppService extends BaseService
{
    public function update(): self
    {
        $this->model->fill($this->getAttributes())->save();

        return $this;
    }

    public function delete(): static
    {
        $this->model->delete();
        return $this;
    }
}
