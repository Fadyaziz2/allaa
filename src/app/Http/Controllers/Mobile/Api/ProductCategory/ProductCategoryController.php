<?php

namespace App\Http\Controllers\Mobile\Api\ProductCategory;

use App\Filters\Invoice\Common\NameFilter;
use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Category\CategoryResourceCollection;
use App\Models\Invoice\Category\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProductCategoryController extends Controller
{
    public function __construct(NameFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index(): JsonResponse
    {
        $categories = Category::query()
            ->filter($this->filter)
            ->whereType('category')
            ->select('id', 'name')
            ->orderByDesc('id')
            ->paginate(request('per_page', 20));

        return success_response('Data fetched successfully', new CategoryResourceCollection($categories));
    }

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
        ]);

        Category::query()->create([
            'name' => $request->name,
            'type' => 'category',
        ]);

        return success_response('Data created successfully');
    }

    public function show(int $id): JsonResponse
    {
        $category = Category::query()->whereType('category')->find($id);
        if (!$category) {
            return error_response('Data not found', 404);
        }

        return success_response('Data fetched successfully', [
            'id' => $category->id,
            'name' => $category->name,
        ]);
    }

    public function update(Request $request, Category $product_category): JsonResponse
    {
        if ($product_category->type !== 'category') {
            return error_response('Data not found', 404);
        }

        $request->validate([
            'name' => ['required', 'string', 'max:255'],
        ]);

        $product_category->update([
            'name' => $request->name,
            'type' => 'category',
        ]);

        return success_response('Data updated successfully');
    }

    public function destroy(Category $product_category): JsonResponse
    {
        if ($product_category->type !== 'category') {
            return error_response('Data not found', 404);
        }

        $product_category->delete();

        return success_response('Data deleted successfully');
    }
}
