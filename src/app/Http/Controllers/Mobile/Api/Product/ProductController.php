<?php

namespace App\Http\Controllers\Mobile\Api\Product;

use App\Filters\Invoice\Product\ProductFilter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Product\ProductRequest;
use App\Http\Resources\Mobile\Product\ProductResource;
use App\Http\Resources\Mobile\Product\ProductResourceCollection;
use App\Models\Invoice\Product\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function __construct(ProductFilter $filter)
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
            ->select(['id', 'name', 'code', 'sku', 'category_id', 'price'])
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
        Product::query()->create($request->all());

        return success_response('Product created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(Product $product): \Illuminate\Http\JsonResponse
    {
        return success_response('Data fetched successfully', $product->makeHidden(['created_at', 'updated_at']));
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
