<?php

namespace App\Http\Controllers\Mobile\Api;

use App\Filters\Invoice\Expense\ExpenseFilter;
use App\Filters\Invoice\Invoice\InvoiceFilter;
use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Report\ExpenseReportResourceCollection;
use App\Http\Resources\Mobile\Report\IncomeReportResourceCollection;
use App\Models\Invoice\Expense\Expense;
use App\Services\Invoice\Invoice\InvoiceService;

class IncomeExpenseReportController extends Controller
{
    public ExpenseFilter $expenseFilter;

    public function __construct(InvoiceService $service, InvoiceFilter $filter, ExpenseFilter $expenseFilter)
    {
        $this->service = $service;
        $this->filter = $filter;
        $this->expenseFilter = $expenseFilter;
    }

    public function incomeReport(): \Illuminate\Http\JsonResponse
    {
        $invoices = $this->service
            ->filter($this->filter)
            ->with(['customer:id,first_name,last_name', 'status:id,name,class'])
            ->orderByDesc('id')
            ->where('received_amount', '>', 0)
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new IncomeReportResourceCollection($invoices));
    }

    public function expenseReport(): \Illuminate\Http\JsonResponse
    {

        $expenses = Expense::query()
            ->filter($this->expenseFilter)
            ->with('category:id,name')
            ->select(['id', 'title', 'date', 'amount'])
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new ExpenseReportResourceCollection($expenses));

    }

}
