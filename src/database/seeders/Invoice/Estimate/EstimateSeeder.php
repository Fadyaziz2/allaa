<?php

namespace Database\Seeders\Invoice\Estimate;

use App\Models\Core\Status\Status;
use App\Models\Invoice\Estimate\Estimate;
use App\Models\Invoice\Product\Product;
use App\Models\User;
use App\Services\Invoice\Customization\CustomizationService;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Log;

class EstimateSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run()
    {
        $this->disableForeignKeys();

        $customers = User::query()->where('is_admin', '<>', 1)->pluck('id')->toArray();
        $estimateSetting = resolve(CustomizationService::class)->index('estimate');
        $products = Product::query()->get();

        // Function to generate a random string for reference number
        function generateRandomString($length = 10)
        {
            return substr(str_shuffle('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 0, $length);
        }

        // Function to identify due invoices
        function getDueInvoices()
        {
            return Estimate::query()->where('status_id', 6)->get(); // 6 is pending
        }

        // Create 1000 invoices
        for ($i = 0; $i < 35; $i++) {
            try {
                $latestInvoiceNumber = Estimate::query()->max('invoice_number') + 1;
                $statusPaid = 6; // Assuming 6 represents 'status_paid'
                $statusDue = 7; // Assuming 7 represents 'status_due'
                $isPaid = random_int(0, 1) === 1;
                $statusId = $isPaid ? $statusPaid : $statusDue;

                $invoice = Estimate::query()->create([
                    'customer_id' => $customers[array_rand($customers)],
                    'date' => now()->format('Y-m-d'),
                    'invoice_number' => $latestInvoiceNumber,
                    'invoice_full_number' => $estimateSetting['estimate_prefix'] . ($estimateSetting['estimate_serial_start'] + $latestInvoiceNumber),
                    'status_id' => $statusId,
                    'sub_total' => 0,
                    'discount_type' => 'none',
                    'discount_amount' => null,
                    'total_amount' => 0,
                    'grand_total' => 0,
                    'note' => '<p>In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.</p>',
                    'estimate_template' => 2,
                    'created_by' => 1
                ]);

                // Add a random number of products (1 to 4) to each estimate
                $numProducts = random_int(1, 4);
                for ($j = 0; $j < $numProducts; $j++) {
                    $randomProduct = $products->random();
                    $estimateDetail = $invoice->estimateDetails()->create([
                        'quantity' => 1,
                        'price' => $randomProduct->price,
                        'product_id' => $randomProduct->id
                    ]);

                    if (!$estimateDetail) {
                        Log::error('Failed to create estimate detail', ['invoice_id' => $invoice->id, 'product_id' => $randomProduct->id]);
                        continue;
                    }

                    // Update the invoice totals
                    $invoice->sub_total += $randomProduct->price;
                    $invoice->total_amount += $randomProduct->price;
                    $invoice->grand_total += $randomProduct->price;
                }

                $invoice->save();

            } catch (\Exception $e) {
                Log::error('Error creating invoice', ['error' => $e->getMessage()]);
            }
        }

        $this->enableForeignKeys();
    }


}
