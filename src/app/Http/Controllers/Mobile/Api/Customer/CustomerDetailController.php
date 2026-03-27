<?php

namespace App\Http\Controllers\Mobile\Api\Customer;

use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Customer\CustomerResource;
use App\Http\Resources\Mobile\Customer\CustomerInvoiceResourceCollection;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\User;

class CustomerDetailController extends Controller
{
    public function details($id): \Illuminate\Http\JsonResponse
    {
        $checkCustomer = $this->checkCustomer($id);
        if (!$checkCustomer) {
            return error_response('Customer not found', 404);
        }

        return success_response('Customer details data fetched successfully', [
            'customer' => CustomerResource::make($checkCustomer),
            'total_amount' => $this->sumQuery($id, 'grand_total'),
            'total_paid_amount' => $this->sumQuery($id, 'received_amount'),
            'total_due_amount' => $this->sumQuery($id, 'due_amount'),
        ]);
    }

    public function detailInvoice($id): \Illuminate\Http\JsonResponse
    {
        $checkCustomer = $this->checkCustomer($id);
        if (!$checkCustomer) {
            return error_response('Customer not found', 404);
        }

        $invoices = Invoice::query()
            ->with('status:id,name,class')
            ->where('customer_id', $id)
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Customer Invoice data fetched successfully', new CustomerInvoiceResourceCollection($invoices));
    }

    private function checkCustomer($id): null|object
    {
        return User::query()
            ->with('profilePicture')
            ->whereHas('role', fn($query) => $query->where('alias', 'customer'))
            ->where('id', $id)
            ->first();
    }

    private function sumQuery($id, $column)
    {
        $invoiceSum =  Invoice::query()
            ->where('customer_id', $id)
            ->sum($column);

        return number_with_currency_symbol($invoiceSum);
    }
}
