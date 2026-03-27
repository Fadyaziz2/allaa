<?php

namespace Database\Seeders\Invoice\Transaction;

use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\PaymentMethod\PaymentMethod;
use App\Models\Invoice\Transaction\Transaction;
use App\Models\User;
use Carbon\Carbon;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class TransactionSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        // Truncate transactions table to start fresh
        Transaction::truncate();

        // Get all invoices with received amounts
        $invoicesWithReceivedAmount = Invoice::where('received_amount', '>', 0)->get();

        // Loop through each invoice and create a transaction
        foreach ($invoicesWithReceivedAmount as $invoice) {
            Transaction::create([
                'invoice_number' => $invoice->invoice_number,
                'invoice_full_number' => $invoice->invoice_full_number,
                'invoice_id' => $invoice->id,
                'customer_id' => $invoice->customer_id,
                'payment_method_id' => PaymentMethod::inRandomOrder()->first()->id, // Get a random payment method
                'received_on' => Carbon::now()->format('Y-m-d'),
                'amount' => $invoice->received_amount,
                'note' => 'Payment received for invoice ' . $invoice->invoice_number,
                'token' => null, // Add logic to generate token if needed
                'received_by' => User::where('is_admin', '<>', 1)->inRandomOrder()->first()->id, // Get a random user who is not an admin
            ]);
        }


        $this->enableForeignKeys();
    }
}
