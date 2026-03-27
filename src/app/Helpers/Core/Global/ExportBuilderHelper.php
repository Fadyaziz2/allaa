<?php

use App\Exports\ExportBuilder;

if (!function_exists('export_builder')) {
    function export_builder($collection, $headings, $title): ExportBuilder
    {

        return (new ExportBuilder())
            ->setHeadings($headings)
            ->setTitle($title)
            ->setCollection($collection)
            ->get();
    }
}

if (!function_exists('getChunk')) {
    function getChunk($skip, $take, $model, $map, array $relation = null)
    {
        return $model::with($relation)
            ->skip($skip)
            ->when($take, fn($model) => $model->take($take))
            ->get()
            ->map($map);
    }
}
