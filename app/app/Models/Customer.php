<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    use HasFactory;

    protected $fillable = [
        'account_number',
        'customer_name',
        'billing_address_1',
        'billing_address_2',
        'billing_city',
        'billing_state',
        'billing_zip',
        'shipping_address_1',
        'shipping_address_2',
        'shipping_city',
        'shipping_state',
        'shipping_zip',
        'phone',
        'email',
        'business_type',
        'shipment_day',
    ];

    protected $casts = [
        'shipment_day' => 'array',
    ];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($customer) {
            $customer->account_number = self::generateUniqueAccountNumber();
        });
    }

    private static function generateUniqueAccountNumber()
    {
        do {
            $accountNumber = bin2hex(random_bytes(5));
        } while (self::where('account_number', $accountNumber)->exists());

        return $accountNumber;
    }
}