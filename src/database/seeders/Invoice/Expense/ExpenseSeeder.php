<?php

namespace Database\Seeders\Invoice\Expense;

use App\Models\Invoice\Category\Category;
use App\Models\Invoice\Expense\Expense;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;
use Illuminate\Support\Carbon;

class ExpenseSeeder extends Seeder
{
    use DisableForeignKeys;

    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Expense::query()->truncate(); // Clear existing data

        $categories = Category::where('type', 'expense')->pluck('id')->toArray();

        $startDate = now()->startOfWeek(); // Get the start of the current week
        $endDate = now()->endOfWeek(); // Get the end of the current week

        $dates = [];
        for ($date = $startDate; $date->lte($endDate); $date->addDay()) {
            $dates[] = $date->copy();
        }

        $amount = rand(1000, 15000); // Random amount between 1000 and 100000
        foreach ($dates as $key => $date) {
            Expense::create([
                'title' => 'Training and learning',
                'date' => $date->format('Y-m-d'),
                'reference' => $this->generateRandomString(5),
                'amount' => $amount,
                'category_id' => $categories[array_rand($categories)],
                'note' => 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
            ]);

            // Add other expenses in a similar manner
        }
    }

    /**
     * Generate a random string.
     *
     * @param int $length
     * @return string
     */
    private function generateRandomString($length = 10)
    {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $randomString = '';
        for ($i = 0; $i < $length; $i++) {
            $randomString .= $characters[rand(0, strlen($characters) - 1)];
        }
        return $randomString;
    }
}
