<?php

namespace App\Http\Controllers\Mobile\Api\Dashboard;

use App\Http\Controllers\Controller;
use App\Services\Mobile\Dashboard\DashboardService;
use Illuminate\Http\Request;

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

        return success_response('Data fetched successfully', [
            'total_amount' => number_with_currency_symbol(round($totalAmount, 2)),
            'total_paid_amount' => number_with_currency_symbol($totalPaidAmount),
            'total_due_amount' => number_with_currency_symbol($totalDueAmount),
            'total_customer' => $this->service->totalCustomer(),
            'total_product' => $this->service->totalProduct(),
            'total_invoice' => $totalInvoices,
            'total_paid_invoice' => $totalPaidInvoices,
            'total_due_invoice' => $totalDueInvoices,
        ]);
    }

    public function incomeOverview($range_type = 0): \Illuminate\Http\JsonResponse
    {
         return success_response('Data fetched successfully', $this->service->manipulateIncomeOverviewChart($range_type));
    }

    public function paymentOverView(): \Illuminate\Http\JsonResponse
    {
        return success_response('Data fetched successfully', $this->service->paymentOverView());
    }
}
