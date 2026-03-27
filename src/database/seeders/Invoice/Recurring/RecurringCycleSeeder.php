<?php

namespace Database\Seeders\Invoice\Recurring;

use App\Models\Invoice\Recurring\RecurringType;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class RecurringCycleSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        $recurringType = [
            [
                'name' => 'every_week',
            ],
            [
                'name' => 'monthly',
            ],
            [
                'name' => 'yearly',
            ],
        ];

        RecurringType::query()->insert($recurringType);

        $this->enableForeignKeys();
    }
}
