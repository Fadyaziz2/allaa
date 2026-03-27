<?php

namespace App\Http\Controllers\Invoice\Unit;

use App\Filters\Invoice\Common\NameFilter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Unit\UnitRequest;
use App\Models\Invoice\Unit\Unit;

class UnitController extends Controller
{
    public function __construct(NameFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index()
    {
        if ($response = check_permission(['create_products', 'update_products', 'manage_global_access'])) {
            return $response;
        }

        return Unit::query()
            ->withCount('products as total_products')
            ->filter($this->filter)
            ->orderByDesc('id')
            ->paginate(request()->get('per_page', 10));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(UnitRequest $request)
    {
        Unit::query()->create($request->only('name', 'short_name'));
        return created_responses('units');
    }

    /**
     * Display the specified resource.
     */
    public function show(Unit $unit)
    {
        return $unit;
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UnitRequest $request, Unit $unit)
    {
        $unit->update($request->only('name', 'short_name'));
        return updated_responses('units');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Unit $unit)
    {
        $unit->delete();
        return deleted_responses('units');
    }
}
