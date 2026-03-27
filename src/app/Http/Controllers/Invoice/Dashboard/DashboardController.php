<?php

namespace App\Http\Controllers\Invoice\Dashboard;

use App\Filters\Invoice\Dashboard\DashboardFilter;
use App\Http\Controllers\Controller;
use App\Models\Invoice\Estimate\Estimate;
use App\Models\Invoice\Expense\Expense;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\Transaction\Transaction;
use App\Services\Invoice\Dashboard\DashboardService;

class DashboardController extends Controller
{
    public function __construct(DashboardService $service)
    {
        $this->service = $service;
    }

    public function statistics(): \Illuminate\Http\JsonResponse
    {
        $totalInvoices = $this->service->invoiceCount();
        $totalPaidInvoices = $this->service->invoiceCount($this->service->status['status_paid']);
        $totalDueInvoices = $this->service->invoiceCount($this->service->status['status_due']);
        $totalAmount = $this->service->invoiceAmount('grand_total');
        $totalPaidAmount = $this->service->invoiceAmount('received_amount');
        $totalDueAmount = $this->service->invoiceAmount('due_amount');

        if (auth()->user()->can('manage_global_access')) {
            return response()->json([
                'total_customer' => $this->service->totalCustomer(),
                'total_product' => $this->service->totalProduct(),
                'total_invoice' => $totalInvoices,
                'total_paid_invoice' => $totalPaidInvoices,
                'total_due_invoice' => $totalDueInvoices,
                'total_amount' => $totalAmount,
                'total_paid_amount' => $totalPaidAmount,
                'total_due_amount' => $totalDueAmount,
            ]);

        } else {
            return response()->json([
                'total_invoice' => $totalInvoices,
                'total_paid_invoice' => $totalPaidInvoices,
                'total_due_invoice' => $totalDueInvoices,
                'total_amount' => $totalAmount,
                'total_paid_amount' => $totalPaidAmount,
                'total_due_amount' => $totalDueAmount,
            ]);
        }
    }

    public function incomeOverview($range_type = 0): object|array
    {
        return $this->service->manipulateIncomeOverviewChart($range_type);
    }

    public function paymentOverView(): array
    {
        $payments = $this->service->paymentOverView();
        $paymentChat = [];

        foreach ($payments as $payment) {
            $paymentChat[trans('default.received_amount')] = $payment->received_amount;
            $paymentChat[trans('default.due_amount')] = $payment->due_amount;
        }

        return ['payment_overview' => $paymentChat];
    }

    public function expenseOverView($range_type = 0): array
    {
        $expense = $this->service->manipulateExpenseOverviewChart($range_type);
        $income = $this->service->manipulateIncomeOverviewChart($range_type);


        $label = $range_type ? $this->service->incomeExpenseLabel($range_type) : [];

        return ['labels' => array_values($label), 'income' => $income, 'expense' => $expense];
    }

    public function incomeExpense(): array
    {
        $income = $this->service->income();
        $expense = $this->service->expense();

        $payments = [
            'income' => $income,
            'expense' => $expense
        ];

        return ['income_expense' => $payments];
    }

    public function recentInvoice(): \Illuminate\Contracts\Pagination\LengthAwarePaginator
    {
        return Invoice::query()
            ->with('customer:id,first_name,last_name', 'status:id,name,class')
            ->orderByDesc('id')
            ->limit(5)
            ->paginate(5);
    }

    public function recentEstimate(): \Illuminate\Contracts\Pagination\LengthAwarePaginator
    {
        return Estimate::query()
            ->with('customer:id,first_name,last_name', 'status:id,name,class')
            ->orderByDesc('id')
            ->limit(5)
            ->paginate(5);
    }

    public function recentTransaction(): \Illuminate\Contracts\Pagination\LengthAwarePaginator
    {
        return Transaction::query()
        ->with(['invoice:id,invoice_full_number', 'customer:id,first_name,last_name', 'paymentMethod'])
            ->orderByDesc('id')
            ->limit(5)
        ->paginate(5);
    }

    public function recentExpense(): \Illuminate\Contracts\Pagination\LengthAwarePaginator
    {
        return Expense::query()
            ->orderByDesc('id')
            ->limit(5)
            ->paginate(5);
    }
}
