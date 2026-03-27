<?php

namespace App\Exceptions\Traits;

use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\QueryException;
use Throwable;

trait ExceptionHelper
{
    public function apiFailResponse($request, Throwable $exception): bool|\Illuminate\Http\JsonResponse
    {
        if ($request->expectsJson() && app()->environment('production')) {
            $message = trans('default.api_failed_response');
            $methodName = 'whenItIs' . $exception->getCode();

            if (method_exists($this, $methodName)) {
                $message = $this->{$methodName}($request, $exception);
            }

            if ($exception instanceof QueryException) {
                return $this->responseMessage($message, 424);
            }

            if ($exception instanceof ModelNotFoundException) {
                $message = trans('default.resource_not_found', ['resource' => trans('default.resource')]);
                return $this->responseMessage($message, 404);
            }
        }
        return false;
    }
}
