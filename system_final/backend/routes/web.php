<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\RegisterController;

// Authentication Routes
Route::middleware(['web'])->group(function () {
    Route::get('/login', [LoginController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [LoginController::class, 'login']);
    Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

    // Registration Routes
    Route::get('/register', [RegisterController::class, 'showRegistrationForm'])->name('register');
    Route::post('/register', [RegisterController::class, 'register']);
});

// Home Route (Protected)
Route::get('/home', function () {
    return view('home');
})->middleware('auth')->name('home');

// Redirect root to login
Route::get('/', function () {
    return redirect('/login');
});

Route::middleware(['auth', 'admin'])->group(function () {
    Route::get('/admin/reviews', function () {
        return view('admin.reviews');
    });
});
