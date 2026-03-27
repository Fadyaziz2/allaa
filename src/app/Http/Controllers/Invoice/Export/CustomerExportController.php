<?php

namespace App\Http\Controllers\Invoice\Export;

use App\Http\Controllers\Controller;
use App\Services\Invoice\Customer\CustomerExportService;

class CustomerExportController extends Controller
{
    public function __construct(CustomerExportService $service)
    {
        $this->service = $service;
    }

    public function export(): \Symfony\Component\HttpFoundation\BinaryFileResponse
    {
        return $this->service->downloadCustomer(0);
    }
}
