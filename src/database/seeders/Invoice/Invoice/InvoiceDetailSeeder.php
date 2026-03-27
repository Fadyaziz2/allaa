<?php

namespace Database\Seeders\Invoice\Invoice;

use App\Models\Invoice\Invoice\InvoiceDetail;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class InvoiceDetailSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        InvoiceDetail::query()->truncate();

        InvoiceDetail::query()->insert([
            [
                'quantity' => 1,
                'price' => 1999,
                'invoice_id' => 1,
                'product_id' => 14
            ],
            [
                'quantity' => 1,
                'price' => 1299,
                'invoice_id' => 2,
                'product_id' => 15
            ],
            [
                'quantity' => 1,
                'price' => 6999,
                'invoice_id' => 3,
                'product_id' => 16
            ],
            [
                'quantity' => 1,
                'price' => 59,
                'invoice_id' => 4,
                'product_id' => 17
            ],
            [
                'quantity' => 1,
                'price' => 59,
                'invoice_id' => 5,
                'product_id' => 17
            ],
            [
                'quantity' => 1,
                'price' => 2.99,
                'invoice_id' => 6,
                'product_id' => 1
            ],
            [
                'quantity' => 1,
                'price' => 4,
                'invoice_id' => 7,
                'product_id' => 3
            ],
        ]);

        $this->enableForeignKeys();
    }
}
