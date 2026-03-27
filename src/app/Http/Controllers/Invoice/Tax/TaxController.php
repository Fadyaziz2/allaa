<?php

namespace App\Http\Controllers\Invoice\Tax;

use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Tax\TaxRequest;
use App\Models\Invoice\Tax\Tax;
use Illuminate\Http\Request;

class TaxController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return Tax::query()
            ->orderBy('id', request()->get('orderBy', 'desc'))
            ->paginate(request()->get('per_page', 10));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(TaxRequest $request)
    {
        Tax::query()->create($request->only('name', 'rate'));
        return created_responses('tax');
    }

    /**
     * Display the specified resource.
     */
    public function show(Tax $tax)
    {
        return $tax;
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(TaxRequest $request, Tax $tax)
    {
        $tax->update($request->only('name', 'rate'));
        return updated_responses('tax');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Tax $tax)
    {
        $tax->delete();
        return deleted_responses('tax');
    }
}
