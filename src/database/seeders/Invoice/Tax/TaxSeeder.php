<?php

namespace Database\Seeders\Invoice\Tax;

use App\Models\Invoice\Tax\Tax;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class TaxSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();
        Tax::query()->truncate();

        Tax::query()->insert([
            [
                'name' => 'GST',
                'rate' => 5.5,
            ],
            [
                'name' => 'GOV',
                'rate' => 7.5,
            ], [
                'name' => 'Default',
                'rate' => 5,
            ]
        ]);
        $this->enableForeignKeys();
    }
}
