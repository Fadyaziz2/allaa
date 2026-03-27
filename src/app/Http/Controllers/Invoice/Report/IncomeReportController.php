<?php

namespace App\Http\Controllers\Invoice\Report;

use App\Filters\Invoice\Invoice\InvoiceFilter;
use App\Http\Controllers\Controller;
use App\Models\Invoice\Invoice\Invoice;
use Illuminate\Http\Request;

class IncomeReportController extends Controller
{
    public function __construct(InvoiceFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index(Request $request)
    {
        $query = Invoice::query()
            ->filter($this->filter)
            ->with(['customer:id,first_name,last_name', 'status:id,name,class'])
            ->orderByDesc('id')
            ->where('received_amount', '>', 0)
            ->orderByDesc('id');

        $totalAmount = $query->sum('received_amount');
        $perPage = $request->input('per_page', 10);
        $expenses = $query->paginate($perPage)->toArray();

        $customData['grand_total'] = ['received_amount' => $totalAmount];

        return array_merge($customData, $expenses);
    }
}
