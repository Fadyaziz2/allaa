<?php

namespace App\Http\Controllers\Invoice\Category;

use App\Filters\Invoice\Common\NameFilter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Category\CategoryRequest;
use App\Models\Invoice\Category\Category;
use Illuminate\Auth\Access\AuthorizationException;
use Psr\Container\ContainerExceptionInterface;
use Psr\Container\NotFoundExceptionInterface;

class CategoryController extends Controller
{
    public function __construct(NameFilter $filter)
    {
        $this->filter = $filter;
    }


    public function index()
    {
        if ($response = check_permission(['create_products',
            'update_products',
            'create_expenses',
            'update_expenses',
            'manage_global_access'])) {
            return $response;
        }
        return Category::query()
            ->filter($this->filter)
            ->withCount('products as total_products')
            ->where('type', request('type', 'category'))
            ->orderByDesc('id')
            ->paginate(request()->get('per_page', 10));
    }

    public function store(CategoryRequest $request)
    {
        Category::query()->create($request->only('name', 'type'));

        return created_responses('category');
    }


    public function show(Category $category): Category
    {
        return $category;
    }


    public function update(CategoryRequest $request, Category $category)
    {
        $category->update($request->only('name', 'type'));
        return updated_responses('category');
    }

    public function destroy(Category $category)
    {
        $category->delete();
        return deleted_responses('category');
    }
}
