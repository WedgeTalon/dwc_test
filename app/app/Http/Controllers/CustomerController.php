<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use Inertia\Inertia;

class CustomerController extends Controller
{
    /**
     * List all customers.
     *
     * @return \Inertia\Response
     */
    public function list()
    {
        $customers = Customer::all();
        return Inertia::render('Customers/List', ['customers' => $customers]);
    }
}
