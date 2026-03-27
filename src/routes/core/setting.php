<?php

use App\Http\Controllers\Core\Installer\Update\AppUpdateController;
use App\Http\Controllers\Core\Setting\CronJobSettingController;
use App\Http\Controllers\Core\Setting\EmailDeliveryCheckController;
use App\Http\Controllers\Core\Setting\EmailSettingController;
use App\Http\Controllers\Core\Setting\SettingController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

Route::group(['prefix' => 'app', 'middleware' => 'admin'], function (Router $route) {

    $route->get('settings', [SettingController::class, 'index'])->name('setting.view');

    $route->post('settings', [SettingController::class, 'update'])->name('setting.update');

    $route->get('general-settings', [SettingController::class, 'generalSettings'])
        ->name('general-setting.view');


    $route->get('settings/email-settings', [EmailSettingController::class, 'index'])
        ->name('email-setting.view');

    $route->post('settings/email-settings', [EmailSettingController::class, 'update'])
        ->name('email-setting.update');

    $route->get('cronjob-settings', [CronJobSettingController::class, 'index'])
        ->name('cronjob.view');

    $route->get('check-verify', [AppUpdateController::class, 'index'])->name('update.check-verify');


});

Route::group(['prefix' => 'app', 'middleware' => ['auth', 'authorize']], function (Router $route) {
    $route->get('exist-mail-setup', [EmailDeliveryCheckController::class, 'isExists'])
        ->middleware('can:view_setting');

    $route->post('send-test-mail', [EmailDeliveryCheckController::class, 'sendTestMail']);

    $route->get('update-app', [AppUpdateController::class, 'checkUpdate'])
        ->name('update.app')->middleware('can:check_verify_update');

    $route->get('update-app/{version}', [AppUpdateController::class, 'update'])
        ->name('install.update-app')
        ->middleware('can:check_verify_update');
});


Route::get('app/public/settings', [SettingController::class, 'index'])->name('settings_view');
