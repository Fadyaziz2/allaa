<?php

namespace App\Http\Controllers\Mobile\Api\Category;

use App\Filters\Invoice\Common\NameFilter;
use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Category\CategoryResourceCollection;
use App\Models\Invoice\Category\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function __construct(NameFilter $filter)
    {
        $this->filter = $filter;
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $categories = Category::query()
            ->filter($this->filter)
            ->whereType('expense')
            ->select('id', 'name')
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new CategoryResourceCollection($categories));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
        ]);

        Category::query()->create([
            'name' => $request->name,
            'type' => 'expense'
        ]);

        return success_response('Data created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(int $id): \Illuminate\Http\JsonResponse
    {
        $category = Category::query()->whereType('expense')->find($id);
        if (!$category) {
            return error_response('Data not found', 404);
        }
        return success_response('Data fetched successfully', [
            'id' => $category->id,
            'name' => $category->name
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Category $category)
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
        ]);

        $category->update([
            'name' => $request->name
        ]);

        return success_response('Data updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Category $category): \Illuminate\Http\JsonResponse
    {
        $category->delete();
        return success_response('Data deleted successfully');
    }
}
