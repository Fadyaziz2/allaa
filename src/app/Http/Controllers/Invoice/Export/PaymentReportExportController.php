<?php

namespace App\Http\Controllers\Invoice\Export;

use App\Http\Controllers\Controller;
use App\Services\Invoice\Export\PaymentReportExportService;
use Illuminate\Http\Request;

class PaymentReportExportController extends Controller
{
    public function __construct(PaymentReportExportService $service)
    {
        $this->service = $service;
    }

    public function export()
    {
        return $this->service->download(0);
    }



}
