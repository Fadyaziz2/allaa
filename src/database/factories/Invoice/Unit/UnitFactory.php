<?php

namespace Database\Factories\Invoice\Unit;

use App\Models\Invoice\Unit\Unit;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Invoice\Unit\Unit>
 */
class UnitFactory extends Factory
{
   protected $model = Unit::class;

    public function definition(): array
    {
        // Realistic unit names and short names
        $unitNames = [
            'Kilogram' => 'kg',
            'Gram' => 'g',
            'Milligram' => 'mg',
            'Liter' => 'L',
            'Milliliter' => 'mL',
            'Meter' => 'm',
            'Centimeter' => 'cm',
            'Millimeter' => 'mm',
            'Inch' => 'in',
            'Foot' => 'ft',
            // Add more units as needed
        ];

        // Randomly select a unit name and its short name
        $unitName = $this->faker->randomElement(array_keys($unitNames));
        $shortName = $unitNames[$unitName];

        return [
            'name' => $unitName,
            'short_name' => $shortName,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }
}
