<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('app');
})->where('vue', '[\/\w\.-]*')->middleware(['install']);


Route::get('cash-clear', [\App\Http\Controllers\InstallDemoController::class, 'cashClear']);


Route::get('install-demo-data', [\App\Http\Controllers\InstallDemoController::class, 'demoData']);

Route::get('/installation', function () {
    return view('app');
});

Route::get('/login', function () {
    return view('login');
})->name('login')->middleware(['install', 'guest']);

Route::get('symlink', function () {
    $target = storage_path("app/public");
    $explode_base_path = explode(DIRECTORY_SEPARATOR, base_path());
    array_pop($explode_base_path);
    $explode_base_path[] = 'storage';
    $path = implode(DIRECTORY_SEPARATOR, $explode_base_path);
    if (!is_dir('storage')) {
        symlink($target, $path);
    }
    return $this;
});

Route::get('storage-link',function(){
   return \Illuminate\Support\Facades\Artisan::call('storage:link');
});

Route::get('{any}', function () {
    return view('app');
})->where('any', '.*');


