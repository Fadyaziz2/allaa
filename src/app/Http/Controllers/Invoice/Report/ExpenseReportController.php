<?php

namespace App\Http\Controllers\Invoice\Report;

use App\Filters\Invoice\Expense\ExpenseFilter;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Mobile\Api\IncomeExpenseReportController;
use App\Models\Invoice\Expense\Expense;
use App\Services\Invoice\Dashboard\DashboardService;
use Illuminate\Http\Request;

class ExpenseReportController extends Controller
{
    public function __construct(DashboardService $service, ExpenseFilter $filter)
    {
        $this->service = $service;
        $this->filter = $filter;
    }

    public function index(Request $request)
    {
        $query = Expense::query()
            ->filter($this->filter)
            ->with('category:id,name')
            ->orderByDesc('id');

        $totalAmount = $query->sum('amount');
        $perPage = $request->input('per_page', 10);
        $expenses = $query->paginate($perPage)->toArray();

        $customData['grand_total'] = ['amount' => $totalAmount];

        return array_merge($customData, $expenses);
    }

}
