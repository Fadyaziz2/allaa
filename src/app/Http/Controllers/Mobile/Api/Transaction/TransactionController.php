<?php

namespace App\Http\Controllers\Mobile\Api\Transaction;

use App\Filters\Invoice\Transaction\TransactionFilter;
use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Transaction\TransactionResourceCollection;
use App\Models\Invoice\Transaction\Transaction;

class TransactionController extends Controller
{
    public function __construct(TransactionFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index()
    {
        $transactions = Transaction::query()
            ->filter($this->filter)
            ->with(['customer:id,first_name,last_name', 'customer.profilePicture', 'paymentMethod:id,name', 'invoice:id,invoice_full_number'])
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new TransactionResourceCollection($transactions));
    }
}
