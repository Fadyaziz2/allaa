<?php

namespace App\Exceptions;

use App\Exceptions\Traits\ExceptionHelper;
use Exception;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Http\JsonResponse;
use Illuminate\Session\TokenMismatchException;
use Symfony\Component\Mailer\Exception\TransportException;
use Throwable;

class Handler extends ExceptionHandler
{
    use ExceptionHelper;

    /**
     * A list of exception types with their corresponding custom log levels.
     *
     * @var array<class-string<\Throwable>, \Psr\Log\LogLevel::*>
     */
    protected $levels = [
        //
    ];

    /**
     * A list of the exception types that are not reported.
     *
     * @var array<int, class-string<\Throwable>>
     */
    protected $dontReport = [
        //
    ];

    /**
     * A list of the inputs that are never flashed to the session on validation exceptions.
     *
     * @var array<int, string>
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    public function render($request, Exception|Throwable $e): \Illuminate\Http\Response|\Illuminate\Http\JsonResponse|bool|\Symfony\Component\HttpFoundation\Response
    {
        if ($this->apiFailResponse($request, $e)) {
            return $this->apiFailResponse($request, $e);
        }

        if ($e instanceof AuthenticationException) {
            return $this->responseMessage($e->getMessage(), 401);
        }
        if ($request->expectsJson() && $e instanceof AuthorizationException) {
            return $this->responseMessage($e->getMessage(), 403);
        }

        if ($request->expectsJson() && $e instanceof TokenMismatchException) {
            $message = trans('default.csrf_token_mismatch_message') == 'default.csrf_token_mismatch_message' ?
                'CSRF token mismatch.' : trans('default.csrf_token_mismatch_message');

            return $this->responseMessage($message, 419);

        }
        if ($e instanceof TransportException) {
            return $this->responseMessage(__('default.email_setup_is_not_correct'), 403);
        }

        return parent::render($request, $e);
    }


    /**
     * Register the exception handling callbacks for the application.
     */
    public function register(): void
    {
        $this->reportable(function (Throwable $e) {
            //
        });
    }

    public function responseMessage($message, $status = 404): JsonResponse
    {
        return response()->json([
            'status' => false,
            'message' => $message,
            'result' => null
        ], $status);
    }
}
