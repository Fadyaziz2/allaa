<?php

namespace App\Http\Controllers\Invoice\Export;

use App\Http\Controllers\Controller;
use App\Services\Invoice\Export\ProductExportService;
use Illuminate\Http\Request;

class ProductExportController extends Controller
{
    public function __construct(ProductExportService $service)
    {
        $this->service = $service;
    }

    public function export()
    {
        return $this->service->download(0);
    }
}
