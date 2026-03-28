<?php

namespace App\Http\Controllers\Invoice\Product;

use App\Filters\Invoice\Product\ProductFilter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Product\ProductRequest;
use App\Models\Invoice\Product\Product;
use App\Services\Invoice\Product\ProductStockService;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class ProductController extends Controller
{
    public function __construct(ProductFilter $filter, protected ProductStockService $stockService)
    {
        $this->filter = $filter;
    }

    public function index()
    {
        return Product::query()
            ->filter($this->filter)
            ->with('category:id,name', 'unit:id,name')
            ->orderBy('id', request()->get('orderBy', 'desc'))
            ->paginate(request('per_page', 10));
    }


    public function store(ProductRequest $request)
    {
        $product = Product::query()->create($request->all());
        $openingQuantity = (float)$request->input('opening_quantity', 0);
        if ($openingQuantity !== 0.0) {
            $this->stockService->adjustStock(
                $product,
                $openingQuantity,
                'opening_stock',
                Product::class,
                $product->id,
                'Opening stock on product creation',
                $request->input('last_purchase_price') ? (float)$request->input('last_purchase_price') : null
            );
        }

        return created_responses('products');
    }

    /**
     * Display the specified resource.
     */
    public function show(Product $product): Product
    {
        return $product->load(['stockMovements' => fn($query) => $query->latest('movement_date')->limit(25)]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(ProductRequest $request, Product $product)
    {
        $product->update($request->all());

        return updated_responses('products');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Product $product)
    {
        $product->delete();
        return deleted_responses('products');
    }
}
