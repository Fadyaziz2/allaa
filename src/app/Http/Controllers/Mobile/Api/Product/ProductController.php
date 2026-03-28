<?php

namespace App\Http\Controllers\Mobile\Api\Product;

use App\Filters\Invoice\Product\ProductFilter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Product\ProductRequest;
use App\Http\Resources\Mobile\Product\ProductResourceCollection;
use App\Models\Invoice\Product\Product;
use App\Services\Invoice\Product\ProductStockService;

class ProductController extends Controller
{
    public function __construct(ProductFilter $filter, protected ProductStockService $stockService)
    {
        $this->filter = $filter;
    }

    /**
     * Display a listing of the resource.
     */
    public function index(): \Illuminate\Http\JsonResponse
    {
        $products = Product::query()
            ->filter($this->filter)
            ->select(['id', 'name', 'code', 'sku', 'category_id', 'price', 'current_quantity', 'alert_quantity', 'last_purchase_price'])
            ->with('category:id,name')
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new ProductResourceCollection($products));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(ProductRequest $request): \Illuminate\Http\JsonResponse
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

        return success_response('Product created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(Product $product): \Illuminate\Http\JsonResponse
    {
        return success_response(
            'Data fetched successfully',
            $product->load(['stockMovements' => fn($query) => $query->latest('movement_date')->limit(25)])
                ->makeHidden(['created_at', 'updated_at'])
        );
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(ProductRequest $request, Product $product): \Illuminate\Http\JsonResponse
    {
        $product->update($request->all());

        return success_response('Product updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Product $product): \Illuminate\Http\JsonResponse
    {
        $product->delete();

        return success_response('Product deleted successfully');
    }
}
