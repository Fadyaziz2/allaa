<?php

namespace App\Http\Controllers\Invoice\Invoice;

use App\Filters\Invoice\Invoice\InvoiceFilter;
use App\Http\Controllers\Controller;
use App\Models\Invoice\Invoice\Invoice;
use Illuminate\Http\Request;

class RecurringInvoiceController extends Controller
{
    public function __construct(InvoiceFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index()
    {
        return Invoice::query()
            ->filter($this->filter)
            ->when(auth()->user()->can('manage_global_access'), fn($query) => $query->with('customer:id,first_name,last_name'))
            ->with('status:id,name,class', 'recurringType:id,name')
            ->where('recurring', 3)
            ->orderBy('id', request('orderBy', 'desc'))
            ->paginate(request('per_page', 10));
    }
}
