<?php

namespace App\Http\Controllers\Invoice\Report;

use App\Filters\Invoice\Transaction\TransactionFilter;
use App\Http\Controllers\Controller;
use App\Models\Invoice\Transaction\Transaction;
use Illuminate\Http\Request;

class TransactionReportController extends Controller
{
    public function __construct(TransactionFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index(): array
    {
        $transaction = Transaction::query()
            ->filter($this->filter)
            ->when(auth()->user()->can('manage_global_access'), fn($query) => $query->with('customer:id,first_name,last_name'))
            ->with(['paymentMethod', 'invoice:id,invoice_full_number'])
            ->orderByDesc('id');

        $custom['grand_total'] = ['amount' => $transaction->sum('amount')];
        $transaction = $transaction->paginate(request('per_page', 10))->toArray();
        return array_merge($custom, $transaction);

    }
}
