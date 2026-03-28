<?php

namespace App\Http\Controllers\Invoice\Wastage;

use App\Exceptions\GeneralException;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Product\WastageRequest;
use App\Models\Invoice\Product\Product;
use App\Models\Invoice\Product\ProductStockMovement;
use App\Services\Invoice\Product\ProductStockService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class WastageController extends Controller
{
    public function __construct(protected ProductStockService $stockService)
    {
    }

    public function index(Request $request)
    {
        return ProductStockMovement::query()
            ->where('type', 'wastage')
            ->with('product:id,name,category_id', 'product.category:id,name')
            ->when($request->filled('category'), fn($q) => $q->whereHas('product', fn($p) => $p->where('category_id', $request->integer('category'))))
            ->when($request->filled('product'), fn($q) => $q->where('product_id', $request->integer('product')))
            ->latest('movement_date')
            ->paginate($request->integer('per_page', 10));
    }

    /**
     * @throws GeneralException
     */
    public function store(WastageRequest $request)
    {
        try {
            DB::beginTransaction();

            $product = Product::query()->findOrFail($request->integer('product_id'));
            $quantity = round((float)$request->input('quantity'), 2);

            if ((float)$product->current_quantity < $quantity) {
                throw new GeneralException(__('default.not_enough_stock'));
            }

            $this->stockService->adjustStock(
                $product,
                -1 * $quantity,
                'wastage',
                'manual_wastage',
                null,
                $request->input('note') ?: 'Manual wastage entry'
            );

            DB::commit();

            return created_responses('wastage');
        } catch (GeneralException $e) {
            DB::rollBack();
            throw $e;
        } catch (\Throwable $e) {
            DB::rollBack();
            throw new GeneralException(__('default.wastage_has_been_created_failed'));
        }
    }
}
