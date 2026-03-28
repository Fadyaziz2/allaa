<?php

namespace App\Services\Invoice\Product;

use App\Models\Invoice\Product\Product;
use App\Models\Invoice\Product\ProductStockMovement;

class ProductStockService
{
    public function adjustStock(
        Product $product,
        float $quantityDelta,
        string $type,
        ?string $referenceType = null,
        ?int $referenceId = null,
        ?string $note = null,
        ?float $unitPrice = null,
        ?string $movementDate = null
    ): ProductStockMovement {
        $newQuantity = round(((float)$product->current_quantity + $quantityDelta), 2);
        $product->update([
            'current_quantity' => $newQuantity,
            'last_purchase_price' => $unitPrice ?? $product->last_purchase_price,
        ]);

        return ProductStockMovement::query()->create([
            'product_id' => $product->id,
            'type' => $type,
            'quantity_change' => round($quantityDelta, 2),
            'quantity_after' => $newQuantity,
            'unit_price' => $unitPrice,
            'reference_type' => $referenceType,
            'reference_id' => $referenceId,
            'note' => $note,
            'movement_date' => $movementDate ?: now(),
        ]);
    }
}
