<?php

namespace App\Exceptions;

use Exception;
use Illuminate\Http\Request;
use Throwable;

class AuthorizeException extends Exception
{
    public function __construct($message = '', $code = 403, Throwable $previous = null)
    {
        parent::__construct($message, $code, $previous);
    }

    public function render(Request $request): \Illuminate\Foundation\Application|\Illuminate\Http\Response|\Illuminate\Http\JsonResponse|\Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\Routing\ResponseFactory
    {
        if ($request->expectsJson()) {
            return error_response($this->getMessage(), null, $this->getCode());
        }

        return error_response('Wrong endpoint');
    }
}
