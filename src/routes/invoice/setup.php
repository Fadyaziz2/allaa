<?php

use App\Http\Controllers\Invoice\Brand\BrandController;
use App\Http\Controllers\Invoice\Category\CategoryController;
use App\Http\Controllers\Invoice\Customization\CustomizationController;
use App\Http\Controllers\Invoice\Customization\EstimateSettingController;
use App\Http\Controllers\Invoice\Customization\InvoiceSettingController;
use App\Http\Controllers\Invoice\Customization\PaymentSettingController;
use App\Http\Controllers\Invoice\Expense\ExpenseController;
use App\Http\Controllers\Invoice\Note\NoteController;
use App\Http\Controllers\Invoice\PaymentMethod\PaymentMethodController;
use App\Http\Controllers\Invoice\Product\ProductController;
use App\Http\Controllers\Invoice\Tax\TaxController;
use App\Http\Controllers\Invoice\Unit\UnitController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

Route::group(['prefix' => 'invoice/setup', 'middleware' => 'admin'], function (Router $router) {

    $router->apiResource('categories', CategoryController::class);
    $router->apiResource('units', UnitController::class);
    $router->apiResource('expenses', ExpenseController::class);
    $router->apiResource('products', ProductController::class);
    $router->apiResource('taxes', TaxController::class);
    $router->apiResource('payment-methods', PaymentMethodController::class);
    $router->apiResource('notes', NoteController::class);
    $router->get('customizations', [CustomizationController::class, 'index'])
        ->name('view.customizations');
    $router->post('invoice-setting', [InvoiceSettingController::class, 'update'])
        ->name('update.invoice-setting');
    $router->post('estimate-setting', [EstimateSettingController::class, 'update'])
        ->name('update.estimate-setting');
    $router->post('payment-setting', [PaymentSettingController::class, 'update'])
        ->name('update.payment-setting');


});


