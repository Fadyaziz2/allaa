<?php

namespace App\Imports;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use App\Models\Invoice\Category\Category;
use App\Models\Invoice\Expense\Expense;
use Maatwebsite\Excel\Concerns\Importable;
use Maatwebsite\Excel\Concerns\SkipsFailures;
use Maatwebsite\Excel\Concerns\SkipsOnFailure;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithBatchInserts;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use Maatwebsite\Excel\Concerns\WithHeadingRow;
use Maatwebsite\Excel\Concerns\WithValidation;
use Maatwebsite\Excel\Validators\Failure;

class ExpenseImport implements ToModel, WithHeadingRow, WithBatchInserts, WithChunkReading, WithValidation, SkipsOnFailure
{
    use Importable, SkipsFailures;


    public function model(array $row): void
    {
        $category = Category::query()
            ->where('type', 'expense')
            ->where('name', $row['category_name'])
            ->first();

        Expense::query()->create([
            'title' => $row['title'],
            'date' => $row['date'],
            'reference' => $row['reference'],
            'amount' => $row['amount'],
            'category_id' => $category->id,
            'note' => $row['note'],
        ]);
    }

    public function batchSize(): int
    {
        return 1000;
    }

    public function chunkSize(): int
    {
        return 1000;
    }

    public function rules(): array
    {
        return [
            '*.title' => ['required', 'max:255'],
            '*.date' => ['required', 'date_format:Y-m-d'],
            '*.amount' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            '*.category_name' => ['required', 'string', 'exists:categories,name'],
        ];
    }

    public array $requiredHeading = [
        'title',
        'date',
        'reference',
        'amount',
        'category_name',
        'note',
    ];
}
