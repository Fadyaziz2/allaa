<?php

use App\Http\Controllers\Invoice\Import\ExpenseImportController;
use App\Http\Controllers\Invoice\Import\ProductImportController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

Route::group(['prefix' => 'import', 'middleware' => 'admin'], function (Router $router) {

    $router->post('product', [ProductImportController::class, 'import'])
        ->name('import.product');

    $router->post('expense', [ExpenseImportController::class, 'import'])
        ->name('import.expense');
});
