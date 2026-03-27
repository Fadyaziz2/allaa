<?php

use App\Http\Controllers\Core\Auth\LoginController;
use App\Http\Controllers\Core\Installer\CompanySettingController;
use App\Http\Controllers\Core\Installer\DatabaseManagerController;
use App\Http\Controllers\Core\Installer\InstallerController;
use App\Http\Controllers\Core\Lang\LanguageController;
use App\Http\Controllers\StripeController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/


Route::middleware('not_install')->group(function () {
    Route::get('installation/requirements', [InstallerController::class, 'index']);
    Route::post('connect/database', [DatabaseManagerController::class, 'setConnect'])->name('connect.database');
    Route::post('user-store', [DatabaseManagerController::class, 'userStore'])->name('user.store');
    Route::post('company-store', [CompanySettingController::class, 'update'])->name('company.store');
    Route::post('email-store', [DatabaseManagerController::class, 'update'])->name('email.store');
    Route::post('setup-skip', [DatabaseManagerController::class, 'setupSkip'])->name('skip-setup');
});


Route::group(['prefix' => 'auth', 'middleware' => ['install', 'guest']], function (Router $router) {

    $router->post('login', [LoginController::class, 'login']);

});

include_route_files(__DIR__ . '/additional/');


include_route_files(__DIR__ . '/core/');


Route::group(['middleware' => ['guest'], 'prefix' => 'users'], function () {

    include_route_files(__DIR__ . '/user/');
});


include_route_files(__DIR__ . '/invoice/');


Route::get('languages/{locale}', [LanguageController::class, 'index']);


