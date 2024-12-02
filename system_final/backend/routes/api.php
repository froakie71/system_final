<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\FrontendAuthController;
use App\Http\Controllers\Api\HotelReviewController;
use App\Models\User;
use Illuminate\Http\Request;

// Reviews routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/reviews', [HotelReviewController::class, 'store']);
    Route::get('/reviews', [HotelReviewController::class, 'index']);
    Route::middleware('auth:sanctum')->get('/users/admins', function (Request $request) {
        $search = $request->query('search');
        
        $admins = User::query()
            ->where(function($query) {
                $query->where('role', 'admin')
                      ->orWhereIn('id', [1, 2, 3]);
            })
            ->when($search, function ($query) use ($search) {
                return $query->where(function($q) use ($search) {
                    $q->where('name', 'like', "%{$search}%")
                      ->orWhere('email', 'like', "%{$search}%");
                });
            })
            ->select(['id', 'name', 'email'])
            ->orderBy('name')
            ->get();
        
        \Log::info('Admin users query result:', ['count' => $admins->count(), 'admins' => $admins]);
        
        return response()->json([
            'data' => $admins,
            'count' => $admins->count()
        ]);
    });
});

// Auth routes
Route::prefix('frontend')->group(function () {
    Route::post('/login', [FrontendAuthController::class, 'login']);
    Route::post('/register', [FrontendAuthController::class, 'register']);
    Route::middleware('auth:sanctum')->post('/logout', [FrontendAuthController::class, 'logout']);
});