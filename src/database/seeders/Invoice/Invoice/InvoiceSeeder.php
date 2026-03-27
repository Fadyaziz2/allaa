<?php

namespace Database\Seeders\Invoice\Invoice;

use App\Models\Core\Status\Status;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\Product\Product;
use App\Models\User;
use App\Services\Invoice\Customization\CustomizationService;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;
use Illuminate\Support\Carbon;

class InvoiceSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run()
    {
        $this->disableForeignKeys();

        $customers = User::query()->where('is_admin', '<>', 1)->pluck('id')->toArray();
        $invoiceSetting = resolve(CustomizationService::class)->index('invoice');
        $products = Product::query()->get();
        $partialPaymentPercentages = [20, 30, 18, 27]; // Predefined percentages

        // Function to generate a random string for reference number
        function generateRandomString($length = 10)
        {
            return substr(str_shuffle('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 0, $length);
        }

        // Function to handle partial payments
        function applyPartialPayment($invoiceId, $amount)
        {
            $invoice = Invoice::find($invoiceId);
            if ($invoice) {
                $invoice->received_amount += $amount;
                $invoice->due_amount -= $amount;
                $invoice->status_id = $invoice->due_amount > 0 ? 5 : 4; // 5 is due, 4 is paid
                $invoice->save();
            }
        }

        // Function to identify due invoices
        function getDueInvoices()
        {
            return Invoice::query()->where('status_id', 5)->get(); // 5 is due
        }

        // Create 5000 invoices
        for ($i = 0; $i < 50; $i++) {
            $latestInvoiceNumber = Invoice::query()->max('invoice_number') + 1;
            $statusPaid = 4; // Assuming 4 represents 'status_paid'
            $statusDue = 5; // Assuming 5 represents 'status_due'

            // Randomly determine if the invoice is paid or due
            $isPaid = random_int(0, 1) === 1;
            $statusId = $isPaid ? $statusPaid : $statusDue;

            // Select a random product for the initial invoice creation
            $item = $products->random();

            // For due invoices, choose a random percentage for partial payment
            if ($isPaid) {
                $receivedAmount = $item->price;
                $dueAmount = 0;
            } else {
                $randomPercentage = $partialPaymentPercentages[array_rand($partialPaymentPercentages)];
                $receivedAmount = $item->price * ($randomPercentage / 100);
                $dueAmount = $item->price - $receivedAmount;
            }

            $invoice = Invoice::query()->create([
                'customer_id' => $customers[array_rand($customers)],
                'issue_date' => Carbon::now()->format('Y-m-d'),
                'due_date' => Carbon::now()->addDays(5)->format('Y-m-d'), // Due date 5 days after issue date
                'reference_number' => generateRandomString(),
                'invoice_number' => $latestInvoiceNumber,
                'invoice_full_number' => $invoiceSetting['invoice_prefix'] . ($invoiceSetting['invoice_serial_start'] + $latestInvoiceNumber),
                'status_id' => $statusId,
                'recurring' => 0,
                'recurring_type_id' => null,
                'sub_total' => 0, // Initialize to 0, will be calculated
                'discount_type' => 'none',
                'discount_amount' => null,
                'total_amount' => 0, // Initialize to 0, will be calculated
                'grand_total' => 0, // Initialize to 0, will be calculated
                'received_amount' => $receivedAmount,
                'due_amount' => $dueAmount,
                'note' => '<p>In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.</p>',
                'invoice_template' => 1,
                'created_by' => 1
            ]);

            // Initialize totals
            $subTotal = 0;
            $grandTotal = 0;
            $totalAmount = 0;
            $receivedAmount = 0;
            $dueAmount = 0;

            // Add a random number of products (1 to 4) to each invoice
            $numProducts = random_int(1, 4);
            for ($j = 0; $j < $numProducts; $j++) {
                $randomProduct = $products->random();
                $invoice->invoiceDetails()->create([
                    'quantity' => 1,
                    'price' => $randomProduct->price,
                    'product_id' => $randomProduct->id
                ]);

                // Update the invoice totals
                $subTotal += $randomProduct->price;
                $totalAmount += $randomProduct->price;
                $grandTotal += $randomProduct->price;

                if (!$isPaid) {
                    $receivedAmount += $randomProduct->price * ($randomPercentage / 100);
                    $dueAmount += $randomProduct->price - ($randomProduct->price * ($randomPercentage / 100));
                } else {
                    $receivedAmount += $randomProduct->price;
                }
            }

            // Update the invoice with calculated totals
            $invoice->sub_total = $subTotal;
            $invoice->total_amount = $totalAmount;
            $invoice->grand_total = $grandTotal;
            $invoice->received_amount = $receivedAmount;
            $invoice->due_amount = $dueAmount;
            $invoice->save();
        }

        $this->enableForeignKeys();
    }


}
