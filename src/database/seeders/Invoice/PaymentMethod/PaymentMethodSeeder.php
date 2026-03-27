<?php

namespace Database\Seeders\Invoice\PaymentMethod;

use App\Models\Invoice\PaymentMethod\PaymentMethod;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class PaymentMethodSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        PaymentMethod::query()->truncate();

        PaymentMethod::query()->insert([
            [
                'name' => 'Cash',
                'type' => 'others'
            ],
            [
                'name' => 'Bank',
                'type' => 'others'
            ],
            [
                'name' => 'Bank Check',
                'type' => 'others'
            ],
            [
                'name' => 'Crypto',
                'type' => 'others'
            ],

        ]);

        $this->enableForeignKeys();
    }
}
