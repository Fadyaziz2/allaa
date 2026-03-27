<?php

namespace Database\Factories\Invoice\Category;

use App\Models\Invoice\Category\Category;
use Illuminate\Database\Eloquent\Factories\Factory;


class CategoryFactory extends Factory
{
    protected $model = Category::class;

    public function definition(): array
    {
        return [
            'name' => $this->faker->unique()->randomElement($this->categories()),
            'type' => $this->faker->randomElement(['category', 'expense']),
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }



    private function categories(): array
    {
        return [
            'Digital services',
            'Cosmetics and body care',
            'Home appliances',
            'Office supplies',
            'Clothing and accessories',
            'Books and magazines',
            'Health and wellness',
            'Automotive',
            'Electronics',
            'Groceries',
            'Furniture',
            'Gardening',
            'Toys and games',
            'Pet supplies',
            'Jewelry',
            'Sporting goods',
            'Outdoor equipment',
            'Musical instruments',
            'Travel and tourism',
            'Footwear',
            'Hardware and tools',
            'Pharmaceuticals',
            'Cleaning supplies',
            'Baby products',
            'Art supplies',
            'Industrial supplies',
            'Bags and luggage',
            'Home decor',
            'Lighting',
            'Kitchenware',
            'Beverages',
            'Stationery',
            'Bathroom supplies',
            'Medical equipment',
            'Camping gear',
            'Fitness equipment',
            'Craft supplies',
            'Building materials',
            'Event supplies',
            'Seasonal items',
            'Software',
            'Games and puzzles',
            'Educational materials',
            'Beauty products',
            'Watches',
            'Small appliances',
            'Lawn and garden',
            'Security equipment',
            'Lighting fixtures',
            'Phone accessories',
            'Computer accessories',
            'Networking equipment',
            'Smart home devices',
            'Wearable technology',
            'Home entertainment',
            'Gaming consoles',
            'Streaming devices',
            'Virtual reality',
            'Augmented reality',
            'Drones',
            '3D printers',
            'Office furniture',
            'Home office supplies',
            'Stationery supplies',
            'Gift items',
            'Party supplies',
            'Wedding supplies',
            'Holiday decorations',
            'Outdoor furniture',
            'Patio furniture',
            'Car accessories',
            'Motorcycle accessories',
            'Bicycle accessories',
            'Boat accessories',
            'RV accessories',
            'Fishing gear',
            'Hunting gear',
            'Archery gear',
            'Skiing gear',
            'Snowboarding gear',
            'Skating gear',
            'Surfing gear',
            'Swimming gear',
            'Scuba diving gear',
            'Snorkeling gear',
            'Sailing gear',
            'Golf equipment',
            'Tennis equipment',
            'Soccer equipment',
            'Basketball equipment',
            'Baseball equipment',
            'Hockey equipment',
            'Volleyball equipment',
            'Cricket equipment',
            'Rugby equipment',
            'Lacrosse equipment',
            'Field hockey equipment',
            'Softball equipment',
            'Boxing equipment',
            'MMA equipment',
            'Wrestling equipment',
            'Martial arts equipment',
            'Gymnastics equipment',
        ];
    }
}
