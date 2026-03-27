<?php

namespace App\Http\Controllers\Invoice\Export;

use App\Http\Controllers\Controller;
use App\Services\Invoice\Export\ExpenseExportService;
use Illuminate\Http\Request;

class ExpensesExportController extends Controller
{
    public function __construct(ExpenseExportService $service)
    {
        $this->service = $service;
    }


    public function export()
    {
        return $this->service->download(0);
    }


}
