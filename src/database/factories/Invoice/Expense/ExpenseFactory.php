<?php

namespace Database\Factories\Invoice\Expense;

use App\Models\Invoice\Category\Category;
use App\Models\Invoice\Expense\Expense;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\Factory;

class ExpenseFactory extends Factory
{
    protected $model = Expense::class;

    public function definition(): array
    {

        return [
            'title' => $this->faker->sentence,
            'date' => $this->faker->dateTimeBetween('2020-12-01')->format('Y-m-d'),
            'reference' => $this->faker->uuid,
            'amount' => $this->faker->randomFloat(2, 10, 1000),
            'category_id' => $this->faker->randomElement(Category::query()->where('type', 'expense')
                ->pluck('id')
                ->toArray()),
            'note' => $this->faker->paragraph,
        ];
    }
}
