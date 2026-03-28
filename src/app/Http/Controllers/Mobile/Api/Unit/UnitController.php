<?php

namespace App\Http\Controllers\Mobile\Api\Unit;

use App\Filters\Invoice\Common\NameFilter;
use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Unit\UnitResourceCollection;
use App\Models\Invoice\Unit\Unit;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UnitController extends Controller
{
    public function __construct(NameFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index(): JsonResponse
    {
        $units = Unit::query()
            ->filter($this->filter)
            ->withCount('products as total_products')
            ->select('id', 'name', 'short_name')
            ->orderByDesc('id')
            ->paginate(request('per_page', 20));

        return success_response('Data fetched successfully', new UnitResourceCollection($units));
    }

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => ['required', 'string', 'max:100'],
        ]);

        Unit::query()->create([
            'name' => $request->name,
            'short_name' => $request->get('short_name', $request->name),
        ]);

        return success_response('Data created successfully');
    }

    public function show(int $id): JsonResponse
    {
        $unit = Unit::query()->find($id);
        if (!$unit) {
            return error_response('Data not found', 404);
        }

        return success_response('Data fetched successfully', [
            'id' => $unit->id,
            'name' => $unit->name,
            'short_name' => $unit->short_name,
            'total_products' => $unit->products()->count(),
        ]);
    }

    public function update(Request $request, Unit $unit): JsonResponse
    {
        $request->validate([
            'name' => ['required', 'string', 'max:100'],
        ]);

        $unit->update([
            'name' => $request->name,
            'short_name' => $request->get('short_name', $request->name),
        ]);

        return success_response('Data updated successfully');
    }

    public function destroy(Unit $unit): JsonResponse
    {
        if ($unit->products()->exists()) {
            return error_response('Cannot delete unit because it is used in products', 422);
        }

        $unit->delete();

        return success_response('Data deleted successfully');
    }
}
