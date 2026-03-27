<?php

namespace App\Services\Invoice\Export;

use App\Models\Invoice\Product\Product;
use App\Services\BaseService;
use Maatwebsite\Excel\Facades\Excel;

class ProductExportService extends BaseService
{
    public function __construct(Product $model)
    {
        $this->model = $model;
    }


    public function download($batch = 0): \Symfony\Component\HttpFoundation\BinaryFileResponse
    {

        $exportCount = config('excel.exports.chunk_size');
        $skip = ($exportCount * $batch) - $exportCount;
        $data = $this->mapper();

        $relations = [
            'category:id,name',
            'unit:id,name'
        ];

        $products = getChunk($skip, $exportCount, $this->model, $data, $relations);


        $title = 'Product Export';

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
            'Name',
            'Price',
            'Code',
            'Category name',
            'Unit name',
            'Description',
        ];
    }

    private function mapper(): \Closure
    {
        return fn($product) => [
            'name' => $product->name,
            'price' => $product->price,
            'code' => $product->code,
            'category_id' => $product->category ? $product->category->name : '',
            'unit_id' => $product->unit ? $product->unit->name : '',
            'description' => $product->description,
        ];
    }
}
