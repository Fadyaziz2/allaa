<?php

namespace App\Http\Controllers\Invoice\Customization;

use App\Http\Controllers\Controller;
use App\Services\Invoice\Customization\CustomizationService;
use Illuminate\Http\Request;

class CustomizationController extends Controller
{

    public function __construct(CustomizationService $service)
    {
        $this->service = $service;
    }

    public function index()
    {
        return $this->service->index(request('type'));
    }

}
