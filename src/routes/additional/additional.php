<?php

use App\Http\Controllers\Core\Notification\NotificationController;
use App\Http\Controllers\Core\Permission\PermissionController;
use App\Http\Controllers\Core\Selectable\CoreSelectableController;
use App\Http\Controllers\Core\User\ProfileController;
use Illuminate\Routing\Router;
use Illuminate\Support\Facades\Route;


Route::controller(ProfileController::class)->group(function (Router $router) {
    $router->group(['prefix' => 'app/user', 'middleware' => ['auth']], function (Router $router) {

        $router->get('profile', 'profile')->name('user_profile');

        $router->post('profile-update', 'update')->name('user_profile_update');

        $router->post('profile-picture', 'profileThumbnail')->name('user_thumbnail_update');

        $router->patch('password-change', 'passwordChange')->name('password_change');

    });
});

Route::controller(NotificationController::class)->group(function (Router $router) {
    $router->group(['prefix' => 'app/user', 'middleware' => ['auth', 'authorize']], function (Router $router) {
        $router->get('notifications', 'index')
            ->middleware('can:manage_global_access');
        $router->patch('read-notifications/{id}', 'markAsRead');
        $router->patch('un-read-notifications/{id}', 'markAsUnread');
        $router->patch('read-all-notifications', 'markAsReadAll');
    });

});

Route::group(['prefix' => 'app/selectable', 'middleware' => ['auth', 'authorize']], function (Router $router) {
    $router->get('permissions', [PermissionController::class, 'index']);

    $router->get('roles', [CoreSelectableController::class, 'roles']);

    $router->get('role/without-users', [CoreSelectableController::class, 'roleWithoutUser']);

    $router->get('notification/template/{notificationType}', [CoreSelectableController::class, 'notificationTemplate'])
        ->middleware('can:view_notification_type');
});
