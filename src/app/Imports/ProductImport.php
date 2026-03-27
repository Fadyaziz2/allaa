<?php

namespace App\Imports;

use App\Http\Requests\CustomRule\MaxDigitsPrecision;
use App\Models\Invoice\Brand\Brand;
use App\Models\Invoice\Category\Category;
use App\Models\Invoice\Product\Product;
use App\Models\Invoice\Unit\Unit;
use Maatwebsite\Excel\Concerns\Importable;
use Maatwebsite\Excel\Concerns\SkipsFailures;
use Maatwebsite\Excel\Concerns\SkipsOnFailure;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithBatchInserts;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use Maatwebsite\Excel\Concerns\WithHeadingRow;
use Maatwebsite\Excel\Concerns\WithValidation;

class ProductImport implements ToModel, WithHeadingRow, WithBatchInserts, WithChunkReading, WithValidation, SkipsOnFailure
{
    use Importable, SkipsFailures;


    public function model(array $row): void
    {
        $unit = Unit::query()->where('name', $row['unit_name'])->first();
        $category = Category::query()->where('name', $row['category_name'])->first();

        Product::query()->create([
            'name' => $row['name'],
            'price' => $row['price'],
            'code' => $row['code'],
            'unit_id' => $unit?->id,
            'category_id' => $category?->id,
            'description' => $row['description']
        ]);
    }

    public function chunkSize(): int
    {
        return 1000;
    }


    public function batchSize(): int
    {
        return 1000;
    }

    public array $requiredHeading = [
        'name',
        'price',
        'code',
        'unit_name',
        'category_name',
        'description',
    ];

    public function rules(): array
    {
        return [
            '*.name' => ['required', 'max:255'],
            '*.price' => ['required', 'numeric', new MaxDigitsPrecision(16)],
            '*.code' => ['required', 'unique:products,code', 'max:50'],
        ];
    }
}
