<?php

namespace Database\Factories\Invoice\Invoice;

use App\Models\Core\Status\Status;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Invoice\Invoice\Invoice>
 */
class InvoiceFactory extends Factory
{
    protected $model = Invoice::class;

    public function definition(): array
    {
        $status = Status::query()
            ->where('type', 'invoice')
            ->pluck('id')
            ->toArray();
        $customer = User::query()
            ->whereHas('roles', fn($query) => $query->where('alias', 'customer'))
            ->pluck('id')
            ->toArray();

        return [
            'customer_id' => $customer[array_rand($customer)],
            'issue_date' => $this->faker->date(),
            'due_date' => $this->faker->date(),
            'invoice_number' => $this->faker->unique()->numberBetween(1000, 9999),
            'invoice_full_number' => $this->faker->unique()->bothify('INV-####-??'),
            'reference_number' => $this->faker->unique()->bothify('REF-####-??'),
            'recurring' => 0,
            'status_id' => $status[array_rand($status)],
            'sub_total' => $this->faker->randomFloat(2, 100, 1000),
            'total_amount' => $this->faker->randomFloat(2, 100, 1000),
            'grand_total' => $this->faker->randomFloat(2, 100, 1000),
            'received_amount' => $this->faker->randomFloat(2, 100, 1000),
            'due_amount' => $this->faker->randomFloat(2, 100, 1000),
            'note' => $this->faker->sentence,
            'invoice_template' => $this->faker->randomElement([1,2,3]),
            'created_by' => 1
        ];
    }
}
