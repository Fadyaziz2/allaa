<?php

namespace App\Http\Controllers\Invoice\Supplier;

use App\Filters\Invoice\Customer\CustomerFilter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Supplier\SupplierRequest;
use App\Models\Invoice\Supplier\Supplier;

class SupplierController extends Controller
{
    public function __construct(CustomerFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index()
    {
        return Supplier::query()
            ->withCount('purchaseInvoices')
            ->orderBy('id', request()->get('orderBy', 'desc'))
            ->paginate(request()->get('per_page', 10));
    }

    public function store(SupplierRequest $request)
    {
        Supplier::query()->create($request->validated());
        return created_responses('supplier');
    }

    public function show(Supplier $supplier): Supplier
    {
        $supplier->append(['total_purchased', 'total_paid', 'total_due']);
        return $supplier;
    }

    public function update(SupplierRequest $request, Supplier $supplier)
    {
        $supplier->update($request->validated());
        return updated_responses('supplier');
    }

    public function destroy(Supplier $supplier)
    {
        $supplier->delete();
        return deleted_responses('supplier');
    }
}
