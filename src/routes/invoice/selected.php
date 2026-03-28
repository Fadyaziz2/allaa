<?php

use App\Http\Controllers\Invoice\Category\CategoryController;
use App\Http\Controllers\Invoice\Selected\SelectedController;
use App\Http\Controllers\Invoice\Unit\UnitController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

Route::group(['prefix' => 'invoice/selected', 'middleware' => ['auth', 'authorize']], function (Router $router) {

    $router->get('categories', [CategoryController::class, 'index']);

    $router->get('units', [UnitController::class, 'index']);

    $router->get('country', [SelectedController::class, 'country']);

    $router->get('customers', [SelectedController::class, 'customer']);

    $router->get('products', [SelectedController::class, 'product']);
    $router->get('suppliers', [SelectedController::class, 'suppliers']);

    $router->get('status', [SelectedController::class, 'status']);

    $router->get('taxes', [SelectedController::class, 'tax']);

    $router->get('recurring-types', [SelectedController::class, 'recurringType']);

    $router->get('payment-methods', [SelectedController::class, 'paymentMethod']);

    $router->get('customer/payment-methods', [SelectedController::class, 'customerPaymentMethod']);

    $router->get('all/payment-methods', [SelectedController::class, 'allPaymentMethod'])
        ->middleware('can:manage_global_access');

    $router->get('notes', [SelectedController::class, 'note']);

});
