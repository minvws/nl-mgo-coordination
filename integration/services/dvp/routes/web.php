<?php

declare(strict_types=1);

use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\RidController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', [AuthController::class, 'login'])->name('login');

Route::post('logout', function () {
    auth()->logout();
    return redirect()->route('login');
})->name('logout');

Route::post('rid/exchange', [RidController::class, 'exchange'])->name('rid.exchange');

Route::get('profile', [AuthController::class, 'profile'])->name('profile');
