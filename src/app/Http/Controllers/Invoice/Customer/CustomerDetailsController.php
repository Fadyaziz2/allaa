<?php

namespace App\Http\Controllers\Invoice\Customer;

use App\Http\Controllers\Controller;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\User;
use Illuminate\Http\Request;

class CustomerDetailsController extends Controller
{
    public function detail(User $customer): array
    {
        $customerDetails = $customer->load('profilePicture', 'userProfile', 'billingAddress.country:id,name');
        $totalInvoiceAmount = $this->sumQuery($customer, 'grand_total');
        $totalPaidAmount = $this->sumQuery($customer, 'received_amount');
        $totalDueAmount = $this->sumQuery($customer, 'due_amount');

        return [
            'customer_details' => $customerDetails,
            'total_invoice_amount' => $totalInvoiceAmount,
            'total_paid_amount' => $totalPaidAmount,
            'total_due_amount' => $totalDueAmount,
        ];
    }

    public function invoiceDetail(User $customer): \Illuminate\Contracts\Pagination\LengthAwarePaginator
    {
        return Invoice::query()
            ->with('status:id,name,class')
            ->where('customer_id', $customer->id)
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));
    }

    private function sumQuery($customer, $column)
    {
        return Invoice::query()
            ->where('customer_id', $customer->id)
            ->sum($column);
    }
}
