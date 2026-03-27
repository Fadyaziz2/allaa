<?php

namespace Database\Factories\Invoice\Product;

use App\Models\Invoice\Category\Category;
use App\Models\Invoice\Unit\Unit;
use Database\Factories\Invoice\Providers\ProductProvider;
use Faker\Generator as FakerGenerator;
use Illuminate\Database\Eloquent\Factories\Factory;


class ProductFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */

    public function definition(): array
    {
        $faker = new FakerGenerator();
        $faker->addProvider(new ProductProvider($faker));

        return [
            'name' => $faker->productName,
            'price' => $this->faker->numberBetween(100, 500),
            'code' => $this->faker->numberBetween(300, 900),
            'unit_id' => $this->faker->randomElement(Unit::query()->pluck('id')->toArray()),
            'category_id' => $this->faker->randomElement(Category::query()->where('type', 'category')->pluck('id')->toArray()),
            'description' => $this->faker->paragraph
        ];
    }
}
