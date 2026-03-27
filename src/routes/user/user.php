<?php

use App\Http\Controllers\Core\Auth\PasswordResetController;
use App\Http\Controllers\Core\Auth\UserJoinController;
use Illuminate\Support\Facades\Route;

Route::post('password-reset', [PasswordResetController::class, 'store']);
Route::post('confirm-password-reset', [PasswordResetController::class, 'confirmPassword']);
Route::post('user-join', [UserJoinController::class, 'join']);
