<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CustomerController extends Controller
{
    /**
     * Validate customer request.
     *
     * @param \Illuminate\Http\Request $request
     * @param int|null $id
     * @return \Illuminate\Contracts\Validation\Validator
     */
    private function validateCustomer(Request $request, $id = null)
    {
        $stateAbbreviations = implode(',', [
            'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
        ]);

        $rules = [
            'customer_name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:customers,email' . ($id ? ",$id" : ''),
            'phone' => 'required|regex:/^\(\d{3}\) \d{3}-\d{4}$/',
            'billing_address_1' => 'required|string|max:255',
            'billing_city' => 'required|string|max:255',
            'billing_state' => "required|string|in:$stateAbbreviations",
            'billing_zip' => 'required|string|max:10',
            'shipping_address_1' => 'required_if:sameAsBilling,false|string|max:255',
            'shipping_city' => 'required_if:sameAsBilling,false|string|max:255',
            'shipping_state' => "required_if:sameAsBilling,false|string|in:$stateAbbreviations",
            'shipping_zip' => 'required_if:sameAsBilling,false|string|max:10',
            'business_type' => 'required|string|max:255',
            'shipment_day' => 'required|array|min:1',
            'shipment_day.*' => 'in:M,T,W,R,F',
        ];

        return Validator::make($request->all(), $rules);
    }
    /**
     * List all customers.
     * 
     * @return \Illuminate\Http\JsonResponse
     */
    public function list()
    {
        $customers = Customer::all();
        return response()->json($customers);
    }
    
     /**
     * Delete a customer.
     *
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy(int $id)
    {
        $customer = Customer::findOrFail($id);
        $customer->delete();

        return response()->json(['message' => 'Customer deleted successfully']);
    }

    /**
     * Create a new customer.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function create(Request $request)
    {
        $validator = $this->validateCustomer($request);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), 'message' => 'Validation failed'], 422);
        }

        $customerData = $request->except('account_number'); // Exclude account_number from being provided
        $customer = Customer::create($customerData);
        return response()->json($customer);
    }

    /**
     * Update a customer.
     *
     * @param \Illuminate\Http\Request $request
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, int $id)
    {
        $validator = $this->validateCustomer($request, $id);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), 'message' => 'Validation failed'], 422);
        }

        $customer = Customer::findOrFail($id);
        $updateData = $request->except('account_number'); // Exclude account_number from being updated
        $customer->update($updateData);
        return response()->json($customer);
    }
}