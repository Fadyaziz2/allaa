<?php

namespace App\Services\Invoice\Export;

use App\Models\Invoice\Expense\Expense;
use App\Services\BaseService;
use Maatwebsite\Excel\Facades\Excel;

class ExpenseExportService extends BaseService
{
    public function __construct(Expense $model)
    {
        $this->model = $model;
    }

    public function download($batch = 0): \Symfony\Component\HttpFoundation\BinaryFileResponse
    {

        $exportCount = config('excel.exports.chunk_size');
        $skip = ($exportCount * $batch) - $exportCount;
        $data = $this->mapper();

        $relations = [
            'category:id,name'
        ];

        $products = getChunk($skip, $exportCount, $this->model, $data, $relations);


        $title = 'Expense Export';

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
            'Title',
            'Date',
            'Category Name',
            'Amount',
            'Reference',
            'Note',
        ];
    }

    private function mapper(): \Closure
    {
        return fn($expense) => [
            'title' => $expense->title,
            'date' => $expense->date,
            'category_id' => $expense->category ? $expense->category->name : '',
            'amount' => $expense->amount,
            'reference' => $expense->reference,
            'note' => $expense->note,


        ];
    }
}
