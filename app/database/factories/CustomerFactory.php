<?php

namespace Database\Factories;

use App\Models\Customer;
use Illuminate\Database\Eloquent\Factories\Factory;

class CustomerFactory extends Factory
{
    protected $model = Customer::class;

    public function definition()
    {
        return [
            'customer_name' => $this->faker->name(),
            'billing_address_1' => $this->faker->streetAddress(),
            'billing_address_2' => $this->faker->optional()->secondaryAddress(),
            'billing_city' => $this->faker->city(),
            'billing_state' => $this->faker->stateAbbr(),
            'billing_zip' => $this->faker->postcode(),
            'shipping_address_1' => $this->faker->streetAddress(),
            'shipping_address_2' => $this->faker->optional()->secondaryAddress(),
            'shipping_city' => $this->faker->city(),
            'shipping_state' => $this->faker->stateAbbr(),
            'shipping_zip' => $this->faker->postcode(),
            'phone' => $this->faker->numerify('(###) ###-####'),
            'email' => $this->faker->unique()->safeEmail(),
            'business_type' => $this->faker->randomElement(['Corporation', 'LLC', 'Sole Proprietor', 'Other']),
            'shipment_day' => $this->faker->randomElements(['M', 'T', 'W', 'R', 'F'], rand(1, 5)),
            'created_at' => $this->faker->dateTimeBetween('-1 year', 'now'),
        ];
    }
}