<?php

use App\Http\Controllers\Invoice\Dashboard\DashboardController;
use Illuminate\Support\Facades\Route;
use Illuminate\Routing\Router;

Route::group(['prefix' => 'app/dashboard', 'middleware' => 'admin'], function (Router $router) {
    $router->get('statistics', [DashboardController::class, 'statistics'])
        ->name('view.dashboard-statistics')
        ->middleware('global');

    $router->get('income-overview/{range_type?}', [DashboardController::class, 'incomeOverview'])
        ->name('dashboard.income-overview');

    $router->get('payment-overview', [DashboardController::class, 'paymentOverView'])
        ->name('dashboard.payment-overview');

    $router->get('expense-overview/{range_type?}', [DashboardController::class, 'expenseOverView'])
        ->name('dashboard.expense-overview');

    $router->get('income-expense', [DashboardController::class, 'incomeExpense'])
        ->name('dashboard.income-expense');

    $router->get('recent-invoice', [DashboardController::class, 'recentInvoice'])
        ->name('dashboard.recent-invoice');

    $router->get('recent-estimate', [DashboardController::class, 'recentEstimate'])
        ->name('dashboard.recent-estimate');

    $router->get('recent-transaction', [DashboardController::class, 'recentTransaction'])
        ->name('dashboard.recent-transaction');

    $router->get('recent-expense', [DashboardController::class, 'recentExpense'])
        ->name('dashboard.recent-expense');
});


