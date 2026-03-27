<?php

namespace Database\Seeders\Invoice\Estimate;

use App\Models\Invoice\Estimate\EstimateDetail;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class EstimateDetailSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        EstimateDetail::query()->truncate();

        EstimateDetail::query()->insert([
            [
                'quantity' => 1,
                'price' => 2.99,
                'estimate_id' => 1,
                'product_id' => 1
            ],
            [
                'quantity' => 1,
                'price' => 3,
                'estimate_id' => 2,
                'product_id' => 2
            ],
            [
                'quantity' => 1,
                'price' => 4,
                'estimate_id' => 2,
                'product_id' => 3
            ],
            [
                'quantity' => 1,
                'price' => 4.99,
                'estimate_id' => 3,
                'product_id' => 4
            ],
            [
                'quantity' => 1,
                'price' => 16.99,
                'estimate_id' => 3,
                'product_id' => 5
            ],
            [
                'quantity' => 1,
                'price' => 10.99,
                'estimate_id' => 4,
                'product_id' => 6
            ],
            [
                'quantity' => 1,
                'price' => 8.99,
                'estimate_id' => 5,
                'product_id' => 7
            ],
            [
                'quantity' => 1,
                'price' => 1.5,
                'estimate_id' => 6,
                'product_id' => 8
            ],
            [
                'quantity' => 1,
                'price' => 2.8,
                'estimate_id' => 7,
                'product_id' => 9
            ],
            [
                'quantity' => 1,
                'price' => 3.8,
                'estimate_id' => 8,
                'product_id' => 10
            ],
            [
                'quantity' => 1,
                'price' => 500,
                'estimate_id' => 9,
                'product_id' => 11
            ],
            [
                'quantity' => 1,
                'price' => 1,
                'estimate_id' => 10,
                'product_id' => 12
            ],
            [
                'quantity' => 1,
                'price' => 500,
                'estimate_id' => 10,
                'product_id' => 11
            ],
            [
                'quantity' => 1,
                'price' => 25,
                'estimate_id' => 11,
                'product_id' => 13
            ],
            [
                'quantity' => 1,
                'price' => 1999,
                'estimate_id' => 12,
                'product_id' => 14
            ],
            [
                'quantity' => 1,
                'price' => 1299,
                'estimate_id' => 13,
                'product_id' => 15
            ],
            [
                'quantity' => 1,
                'price' => 6999,
                'estimate_id' => 14,
                'product_id' => 16
            ],
            [
                'quantity' => 1,
                'price' => 59,
                'estimate_id' => 15,
                'product_id' => 17
            ],
            [
                'quantity' => 1,
                'price' => 59,
                'estimate_id' => 16,
                'product_id' => 17
            ],
            [
                'quantity' => 1,
                'price' => 2.99,
                'estimate_id' => 17,
                'product_id' => 1
            ],
            [
                'quantity' => 1,
                'price' => 4,
                'estimate_id' => 17,
                'product_id' => 3
            ],
        ]);

        $this->enableForeignKeys();
    }
}
