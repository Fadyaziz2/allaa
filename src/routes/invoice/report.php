<?php

use App\Http\Controllers\Invoice\Report\ExpenseReportController;
use App\Http\Controllers\Invoice\Report\IncomeReportController;
use App\Http\Controllers\Invoice\Report\TransactionReportController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

Route::group(['prefix' => 'app/report', 'middleware' => 'admin'], function (Router $router) {

    $router->get('expense', [ExpenseReportController::class, 'index'])
        ->name('view.expense-report');

    $router->get('income', [IncomeReportController::class, 'index'])
        ->name('view.income-report');

    $router->get('transaction', [TransactionReportController::class, 'index'])
        ->name('view.transaction-report')
        ->middleware('global');

    $router->get('payment', [TransactionReportController::class, 'index'])
        ->name('view.payment-report')
        ->middleware('global');
});
