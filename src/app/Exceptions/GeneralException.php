<?php

namespace App\Exceptions;

use Exception;
use Illuminate\Http\Request;
use Throwable;

class GeneralException extends Exception
{
    public function __construct($message = '', $code = 403, Throwable $previous = null)
    {
        parent::__construct($message, $code, $previous);
    }

    public function report()
    {
        //
    }


    public function render(Request $request)
    {
        if ($request->expectsJson()) {
            return response(['status' => false, 'message' => $this->getMessage()], $this->getCode());
        }
    }
}
