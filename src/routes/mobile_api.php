<?php

use App\Http\Controllers\Core\Permission\PermissionController;
use App\Http\Controllers\Invoice\Estimate\EstimateDownloadController;
use App\Http\Controllers\Invoice\Invoice\InvoiceDownloadController;
use App\Http\Controllers\Mobile\Api\Administrator\RoleController;
use App\Http\Controllers\Mobile\Api\Administrator\UserController;
use App\Http\Controllers\Mobile\Api\Administrator\UserInviteController;
use App\Http\Controllers\Mobile\Api\Auth\LoginController;
use App\Http\Controllers\Mobile\Api\Auth\PasswordResetController;
use App\Http\Controllers\Mobile\Api\Category\CategoryController;
use App\Http\Controllers\Mobile\Api\Customer\CustomerDetailController;
use App\Http\Controllers\Mobile\Api\Dashboard\DashboardController;
use App\Http\Controllers\Mobile\Api\Estimate\EstimateController;
use App\Http\Controllers\Mobile\Api\Estimate\EstimateToInvoiceConvertController;
use App\Http\Controllers\Mobile\Api\Expense\ExpenseController;
use App\Http\Controllers\Mobile\Api\IncomeExpenseReportController;
use App\Http\Controllers\Mobile\Api\Invoice\InvoiceCloneController;
use App\Http\Controllers\Mobile\Api\Invoice\InvoiceController;
use App\Http\Controllers\Mobile\Api\Invoice\InvoiceDuePaymentController;
use App\Http\Controllers\Mobile\Api\Note\NoteController;
use App\Http\Controllers\Mobile\Api\Notification\NotificationController;
use App\Http\Controllers\Mobile\Api\PaymentMethod\PaymentMethodController;
use App\Http\Controllers\Mobile\Api\Product\ProductController;
use App\Http\Controllers\Mobile\Api\ProductCategory\ProductCategoryController;
use App\Http\Controllers\Mobile\Api\Customer\CustomerController;
use App\Http\Controllers\Mobile\Api\Profile\ProfileController;
use App\Http\Controllers\Mobile\Api\Selected\SelectedController;
use App\Http\Controllers\Mobile\Api\Setting\ApiSettingController;
use App\Http\Controllers\Mobile\Api\Tax\TaxController;
use App\Http\Controllers\Mobile\Api\Transaction\TransactionController;
use App\Http\Controllers\Mobile\Api\Unit\UnitController;
use App\Http\Controllers\Mobile\Api\Wastage\WastageController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

Route::prefix('mobile/auth')->middleware('guest')->group(function (Router $router) {

    $router->post('login', [LoginController::class, 'login']);
    $router->post('generate-otp', [PasswordResetController::class, 'generateOtp']);
    $router->post('verify-otp', [PasswordResetController::class, 'verifyOtp']);
    $router->post('confirm-password', [PasswordResetController::class, 'confirmPassword']);
});

Route::prefix('mobile/selected')->middleware(['auth', 'authorize'])->group(callback: function (Router $router) {

    $router->get('categories', [SelectedController::class, 'categories']);
    $router->get('category-list', [SelectedController::class, 'categories']);
    $router->get('units', [SelectedController::class, 'units']);
    $router->get('note-types', [SelectedController::class, 'noteTypes']);
    $router->get('payment-methods', [SelectedController::class, 'paymentMethods']);
    $router->get('customers', [SelectedController::class, 'customers']);
    $router->get('products', [SelectedController::class, 'products']);
    $router->get('taxes', [SelectedController::class, 'taxes']);
    $router->get('notes', [SelectedController::class, 'notes']);
    $router->get('discount-types', [SelectedController::class, 'discountTypes']);
    $router->get('payment-method-lists', [SelectedController::class, 'paymentMethodList']);
    $router->get('customer-payment-method', [SelectedController::class, 'customerPaymentMethod'])
        ->middleware('can:customer_due_invoice_payment');
    $router->get('settings', [ApiSettingController::class, 'index']);
    $router->get('roles', [SelectedController::class, 'roles']);

});

Route::controller(NotificationController::class)->prefix('mobile')
    ->middleware('auth:api')->group(function (Router $router) {
        $router->get('get-unread-notification', 'getUnreadNotifications');
        $router->get('notifications', 'index');
        $router->patch('read-all-notifications', 'markAsReadAll');
    });

Route::controller(ProfileController::class)->prefix('mobile')
    ->middleware('auth:api')->group(function (Router $router) {

        $router->get('my-profile', 'profile');

        $router->post('my-profile', 'update');

    });

// Support

Route::prefix('mobile')->middleware(['auth', 'authorize'])->group(callback: function (Router $router) {
    $router->patch('customer-update-status/{customer}', [CustomerController::class, 'updateStatus'])
        ->middleware('can:update_customers');

    $router->get('customers-invoice-details/{id}', [CustomerDetailController::class, 'detailInvoice'])
        ->middleware('can:details_view_customer');
});

Route::prefix('mobile')->middleware('admin')->group(callback: function (Router $router) {

    $router->group(['prefix' => 'dashboard'], function (Router $router) {

        $router->get('statistics', [DashboardController::class, 'statistics'])
            ->name('view.dashboard-statistics')
            ->middleware('global');

        $router->get('income-overview/{range_type?}', [DashboardController::class, 'incomeOverview'])
            ->name('dashboard.income-overview');

        $router->get('payment-overview', [DashboardController::class, 'paymentOverView'])
            ->name('dashboard.payment-overview');
    });

    // Customer
    $router->apiResource('customers', CustomerController::class);

    $router->get('customer-resend-portal-access/{customer}', [CustomerController::class, 'reSendPortalAccess'])
        ->name('resend_portal_access.customer');

    $router->get('customers-details/{id}', [CustomerDetailController::class, 'details'])
        ->name('customer.details-view');


    $router->apiResource('products', ProductController::class);
    $router->apiResource('wastages', WastageController::class)->only(['index', 'store']);

    $router->apiResource('categories', CategoryController::class);
    $router->apiResource('product-categories', ProductCategoryController::class);
    $router->apiResource('units', UnitController::class);

    $router->apiResource('expenses', ExpenseController::class);

    $router->get('transactions', [TransactionController::class, 'index'])
        ->name('transactions.index')
        ->middleware('global');

    // Estimate
    $router->apiResource('estimates', EstimateController::class)
        ->middleware('global');

    $router->get('estimate-send-attachment/{estimate}', [EstimateController::class, 'sendAttachment'])
        ->name('estimate.resend-mail');

    $router->patch('estimate-update-status/{estimate}', [EstimateController::class, 'statusChange'])
        ->name('estimate.status-change');

    $router->get('estimate-invoice-convert/{estimate}', [EstimateToInvoiceConvertController::class, 'invoiceConvert'])
        ->name('estimate.invoice-convert');

    $router->get('estimate-download/{estimate}', [EstimateDownloadController::class, 'download'])
        ->name('estimate.download');

    $router->get('thermal-estimate-download/{estimate}', [EstimateDownloadController::class, 'thermalEstimatePreview'])
        ->name('thermal-estimate.download');

    // Invoices
    $router->apiResource('invoices', InvoiceController::class)->middleware('global');

    $router->get('invoice-send-attachment/{invoice}', [InvoiceController::class, 'sendAttachment'])
        ->name('invoice.send-attachment');

    $router->get('invoice-clone/{invoice}', [InvoiceCloneController::class, 'store'])
        ->name('invoice-clone');

    $router->post('invoice-due-payment/{invoice}', [InvoiceDuePaymentController::class, 'duePayment'])
        ->name('invoice.due-payment');

    $router->get('invoice-download/{invoice}', [InvoiceDownloadController::class, 'download'])
        ->name('invoice.download');

    $router->get('thermal-invoice-download/{invoice}', [InvoiceDownloadController::class, 'thermalInvoicePreview'])
        ->name('thermal-invoice.download');

    $router->post('invoice-customer-due-payment/{invoice}', [InvoiceDuePaymentController::class, 'duePayment'])
        ->name('due-invoice-payment.customer');

    // Settings
    $router->apiResource('taxes', TaxController::class);

    $router->apiResource('notes', NoteController::class);

    $router->apiResource('payment-methods', PaymentMethodController::class);

    // Reports
    $router->get('income-report', [IncomeExpenseReportController::class, 'incomeReport'])
        ->name('view.income-report')
        ->middleware('global');

    $router->get('expense-report', [IncomeExpenseReportController::class, 'expenseReport'])
        ->name('view.expense-report');

});

// User role management
Route::prefix('mobile')->middleware(['auth', 'authorize'])->group(callback: function (Router $router) {
    $router->apiResource('roles', RoleController::class);
    $router->apiResource('users', UserController::class);
    $router->get('permissions', [PermissionController::class, 'index']);
    $router->post('user-invite', [UserInviteController::class, 'invite'])
        ->name('user-invite');
});

