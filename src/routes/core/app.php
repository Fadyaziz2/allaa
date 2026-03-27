<?php

use App\Http\Controllers\Core\Notification\NotificationTemplateController;
use App\Http\Controllers\Core\Notification\NotificationTypeController;
use App\Http\Controllers\Core\Role\DetachUserRoleController;
use App\Http\Controllers\Core\Role\RoleController;
use App\Http\Controllers\Core\User\UserController;
use App\Http\Controllers\Core\User\UserInviteController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;

Route::group(['prefix' => 'app', 'middleware' => 'admin'], function (Router $route) {

    $route->apiResource('users', UserController::class);
    $route->apiResource('roles', RoleController::class);
    $route->patch('detach/user-role/{user}', [DetachUserRoleController::class, 'detach'])
        ->name('role.detach-user');
    $route->post('attach/user-role/{role}', [DetachUserRoleController::class, 'attach'])
        ->name('role.attach-user');


    $route->apiResource('notification-type', NotificationTypeController::class)
        ->except(['store', 'destroy']);

    $route->patch('notification/template/{template}', [NotificationTemplateController::class, 'update'])
        ->name('notification-template.update');

    $route->post('user-invite', [UserInviteController::class, 'invite'])
        ->name('user-invite');


});
