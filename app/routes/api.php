<?php
use App\Http\Controllers\Api\CustomerController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::get('/customers', [CustomerController::class, 'list']);
    Route::post('/customers', [CustomerController::class, 'create']);
    Route::put('/customers/{id}', [CustomerController::class, 'update']);
    Route::delete('/customers/{id}', [CustomerController::class, 'destroy']);
});