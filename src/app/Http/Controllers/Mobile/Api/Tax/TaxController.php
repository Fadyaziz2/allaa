<?php

namespace App\Http\Controllers\Mobile\Api\Tax;

use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Tax\TaxRequest;
use App\Http\Resources\Mobile\Tax\TaxResourceCollection;
use App\Models\Invoice\Tax\Tax;
use Illuminate\Http\Request;

class TaxController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): \Illuminate\Http\JsonResponse
    {
        $taxes = Tax::query()
            ->select('id', 'name', 'rate')
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new TaxResourceCollection($taxes));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(TaxRequest $request): \Illuminate\Http\JsonResponse
    {
        Tax::query()->create($request->only('name', 'rate'));

        return success_response('Tax created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(Tax $tax): \Illuminate\Http\JsonResponse
    {
        return success_response('Data fetched successfully', $tax->makeHidden(['created_at', 'updated_at']));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(TaxRequest $request, Tax $tax)
    {
        $tax->update($request->only('name', 'rate'));

        return success_response('Tax updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Tax $tax): \Illuminate\Http\JsonResponse
    {
        $tax->delete();

        return success_response('Tax deleted successfully');
    }
}
