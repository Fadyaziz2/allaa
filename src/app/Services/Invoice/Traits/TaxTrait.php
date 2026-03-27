<?php

namespace App\Services\Invoice\Traits;

trait TaxTrait
{
    public function taxes(): static
    {
        foreach (request()->get('taxes') as $item) {
            if (isset($item['id'])) {
                $this->model->taxes()
                    ->where('id', $item['id'])
                    ->update([
                        'tax_id' => $item['tax_id'],
                        'total_amount' => ($this->getAttribute('total_amount') * ($item['rate'] / 100)),
                    ]);
            } else {
                $this->model->taxes()->create([
                    'tax_id' => $item['tax_id'],
                    'total_amount' => ($this->getAttribute('total_amount') * ($item['rate'] / 100)),
                ]);
            }
        }

        return $this;
    }
}
