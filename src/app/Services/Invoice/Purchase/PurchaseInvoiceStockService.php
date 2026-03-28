<?php

namespace App\Services\Invoice\Purchase;

use App\Models\Invoice\Product\Product;
use App\Models\Invoice\Purchase\PurchaseInvoice;
use App\Services\Invoice\Product\ProductStockService;

class PurchaseInvoiceStockService
{
    public function __construct(private readonly ProductStockService $stockService)
    {
    }

    public function apply(PurchaseInvoice $invoice): void
    {
        $invoice->loadMissing('items');
        foreach ($invoice->items as $item) {
            $product = Product::query()->find($item->product_id);
            if ($product) {
                $this->stockService->adjustStock(
                    $product,
                    (float)$item->quantity,
                    'purchase',
                    PurchaseInvoice::class,
                    $invoice->id,
                    'Purchase invoice #' . $invoice->invoice_number,
                    (float)$item->unit_price,
                    (string)$invoice->invoice_date
                );
            }
        }
    }

    public function rollback(PurchaseInvoice $invoice): void
    {
        $invoice->loadMissing('items');
        foreach ($invoice->items as $item) {
            $product = Product::query()->find($item->product_id);
            if ($product) {
                $this->stockService->adjustStock(
                    $product,
                    -1 * (float)$item->quantity,
                    'purchase_reverse',
                    PurchaseInvoice::class,
                    $invoice->id,
                    'Rollback purchase invoice #' . $invoice->invoice_number,
                    null,
                    now()->toDateString()
                );
            }
        }
    }
}
