<?php

use App\Http\Controllers\Invoice\Customer\CustomerDetailsController;
use App\Http\Controllers\Invoice\Invoice\InvoiceCloneController;
use App\Http\Controllers\Invoice\Invoice\InvoiceDownloadController;
use App\Http\Controllers\Invoice\Invoice\RecurringInvoiceController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Invoice\Invoice\InvoiceController;
use App\Http\Controllers\Invoice\Customer\CustomerController;
use App\Http\Controllers\Invoice\Invoice\InvoicePaymentController;
use App\Http\Controllers\Invoice\Transaction\TransactionController;
use App\Http\Controllers\Invoice\Invoice\DueInvoicePaymentController;


Route::group(['middleware' => 'admin'], function (Router $router) {

    $router->apiResource('invoices', InvoiceController::class)->middleware('global');

    $router->post('invoice/send-attachment/{invoice}', [InvoiceController::class, 'sendAttachment'])
        ->name('invoice.send-attachment');

    $router->post('invoice/clone/{invoice}', [InvoiceCloneController::class, 'store'])
        ->name('invoice-clone');

    $router->post('invoice/due-payment/{invoice}', [DueInvoicePaymentController::class, 'duePayment'])
        ->name('invoice.due-payment');

    $router->post('invoice/payment/{invoice}', [InvoicePaymentController::class, 'payment'])
        ->name('due-invoice-payment.customer');

    $router->get('invoice-download/{invoice}', [InvoiceDownloadController::class, 'download'])
        ->name('invoice.download');

    $router->get('thermal-invoice/{invoice}', [InvoiceDownloadController::class, 'thermalInvoicePreview'])
        ->name('invoice.thermal');

    $router->get('recurring-invoices', [RecurringInvoiceController::class, 'index'])
        ->name('recurring.invoice-view')
        ->middleware('global');


    $router->apiResource('customers', CustomerController::class);

    $router->patch('customer/resend-portal-access/{customer}', [CustomerController::class, 'reSendPortalAccess'])
        ->name('resend_portal_access.customer');

    $router->get('customer/details/{customer}', [CustomerDetailsController::class, 'detail'])
        ->name('customer.details-view');


    $router->apiResource('transactions', TransactionController::class)->middleware('global');
});

// Support Route

Route::group(['middleware' => ['auth', 'authorize']], function (Router $router) {
    $router->get('customer/invoice-details/{customer}', [CustomerDetailsController::class, 'invoiceDetail'])
        ->name('customer.invoice-details')
        ->middleware('can:details_view_customer');
});

Route::get('paypal/payment-execute', [InvoicePaymentController::class, 'successTransaction'])
    ->name('paypal.payment-execute');

Route::get('payment-cancel', function () {
    return redirect()->intended('invoices?payment=cancel');
})->name('paypal.payment-cancel');



