<?php

namespace Database\Seeders\Invoice\Setting;

use App\Models\Invoice\Customization\Customization;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class CustomizationSettingSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        Customization::query()->truncate();

        Customization::query()->insert([
            //Invoice
            [
                'name' => 'invoice_prefix',
                'value' => 'invoice-',
                'type' => 'invoice'
            ],
            [
                'name' => 'invoice_serial_start',
                'value' => 1000,
                'type' => 'invoice'
            ],
            [
                'name' => 'invoice_logo',
                'value' => '/assets/images/logo.svg',
                'type' => 'invoice'
            ],
            [
                'name' => 'thermal_printer',
                'value' => 'enable',
                'type' => 'invoice'
            ],

            //Estimate
            [
                'name' => 'estimate_prefix',
                'value' => 'quotation-',
                'type' => 'estimate'
            ],
            [
                'name' => 'estimate_serial_start',
                'value' => 100,
                'type' => 'estimate'
            ],
            [
                'name' => 'estimate_logo',
                'value' => '/assets/images/logo.svg',
                'type' => 'estimate'
            ],
            [
                'name' => 'thermal_printer',
                'value' => 'disable',
                'type' => 'estimate'
            ],

            //Payment
            [
                'name' => 'payment_prefix',
                'value' => 'payment-',
                'type' => 'payment'
            ],
            [
                'name' => 'payment_serial_start',
                'value' => 100,
                'type' => 'payment'
            ]
        ]);

        $this->enableForeignKeys();
    }
}
