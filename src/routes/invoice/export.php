<?php

use App\Http\Controllers\Invoice\Export\CustomerExportController;
use App\Http\Controllers\Invoice\Export\ExpensesExportController;
use App\Http\Controllers\Invoice\Export\PaymentReportExportController;
use App\Http\Controllers\Invoice\Export\ProductExportController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

Route::group(['prefix' => 'export', 'middleware' => 'admin'], function (Router $router) {
    $router->get('customer', [CustomerExportController::class, 'export'])
        ->name('export.customer');

    $router->get('product', [ProductExportController::class, 'export'])
        ->name('export.product');

    $router->get('expense', [ExpensesExportController::class, 'export'])
        ->name('export.expense');

    $router->get('payment', [PaymentReportExportController::class, 'export'])
        ->name('export.payment');
});
