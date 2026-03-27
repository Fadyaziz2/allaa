<?php

namespace Database\Factories\Invoice\Invoice;

use App\Models\Invoice\Invoice\InvoiceDetail;
use App\Models\Invoice\Product\Product;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Invoice\Invoice\InvoiceDetails>
 */
class InvoiceDetailsFactory extends Factory
{
    protected $model = InvoiceDetail::class;

    public function definition(): array
    {
        return [
            'quantity' => $this->faker->numberBetween(1, 100),
            'price' => $this->faker->randomFloat(2, 1, 1000),
            'product_id' => Product::factory(), // Assuming the Product model factory exists
        ];
    }
}
