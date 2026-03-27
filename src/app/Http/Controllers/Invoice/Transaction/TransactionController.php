<?php

namespace App\Http\Controllers\Invoice\Transaction;

use App\Filters\Invoice\Transaction\TransactionFilter;
use App\Http\Controllers\Controller;
use App\Models\Invoice\Transaction\Transaction;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function __construct(TransactionFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index()
    {

        if (auth()->user()->can('manage_global_access')) {
            return Transaction::query()
                ->filter($this->filter)
                ->with(['invoice:id,invoice_full_number', 'customer:id,first_name,last_name', 'paymentMethod'])
                ->orderByDesc('id')
                ->paginate(request('per_page', 10));
        } else {
            $paginator = Transaction::query()
                ->filter($this->filter)
                ->with(['invoice:id,invoice_full_number', 'paymentMethod'])
                ->orderByDesc('id')
                ->paginate(request('per_page', 10));
            $data = $paginator->getCollection();
            $data->each(fn($item) => $item->setHidden(['note']));
            $paginator->setCollection($data);
            return $paginator;
        }
    }
}
