<?php

namespace App\Services\Invoice\Export;

use App\Models\Invoice\Transaction\Transaction;
use App\Services\BaseService;
use Maatwebsite\Excel\Facades\Excel;

class PaymentReportExportService extends BaseService
{
    public function __construct(Transaction $model)
    {
        $this->model = $model;
    }

    public function download($batch = 0): \Symfony\Component\HttpFoundation\BinaryFileResponse
    {

        $exportCount = config('excel.exports.chunk_size');
        $skip = ($exportCount * $batch) - $exportCount;
        $data = $this->mapper();

        $relations = [
            'customer:id,first_name,last_name',
            'invoice:id,invoice_full_number',
            'paymentMethod:id,name',
        ];

        $products = getChunk($skip, $exportCount, $this->model, $data, $relations);


        $title = 'Payment Report Export';

        return Excel::download(export_builder(
            $products,
            $this->getHeadings(),
            $title
        ), "$title-$batch.xlsx"
        );
    }

    private function getHeadings(): array
    {
        return [
            'Payment number',
            'Payment date',
            'Customer name',
            'Reference invoice number',
            'Payment method',
            'Amount',
        ];
    }

    private function mapper(): \Closure
    {
        return fn($transaction) => [
            'invoice_full_number' => $transaction->invoice_full_number,
            'received_on' => $transaction->received_on,
            'customer_id' => $transaction->customer ? $transaction->customer->full_name : '',
            'ref_invoice_number' => $transaction->invoice_full_number,
            'payment_method_id' => $transaction->paymentMethod ? $transaction->paymentMethod->name : '',
            'amount' => $transaction->amount,
        ];
    }
}
