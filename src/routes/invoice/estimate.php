<?php

use App\Http\Controllers\Invoice\Estimate\EstimateController;
use App\Http\Controllers\Invoice\Estimate\EstimateDownloadController;
use App\Http\Controllers\Invoice\Estimate\EstimateToInvoiceConvert;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

Route::group(['middleware' => 'admin'], function (Router $router) {

    $router->apiResource('estimates', EstimateController::class)->middleware('global');
    $router->get('estimate/resend-mail/{estimate}', [EstimateController::class, 'reSendMail'])
        ->name('estimate.resend-mail');
    $router->patch('estimate/status-change/{estimate}', [EstimateController::class, 'statusChange'])
        ->name('estimate.status-change');
    $router->get('estimate/invoice-convert/{estimate}', [EstimateToInvoiceConvert::class, 'invoiceConvert'])
        ->name('estimate.invoice-convert');
    $router->get('estimate-download/{estimate}', [EstimateDownloadController::class, 'download'])
        ->name('estimate.download');

    $router->get('thermal-estimate/{estimate}', [EstimateDownloadController::class, 'thermalEstimatePreview'])
        ->name('invoice.thermal');
});
