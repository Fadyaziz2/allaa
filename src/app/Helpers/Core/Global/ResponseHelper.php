<?php

use App\Helpers\Core\General\ResponseHelper;

if (!function_exists('created_responses')) {
    function created_responses($name, $data = [])
    {
        return resolve(ResponseHelper::class)->createdResponse($name, $data);
    }
}

if (!function_exists('updated_responses')) {
    function updated_responses($name, $data = [])
    {
        return resolve(ResponseHelper::class)->updatedResponse($name, $data);
    }
}

if (!function_exists('deleted_responses')) {
    function deleted_responses($name, $data = [])
    {
        return resolve(ResponseHelper::class)->deletedResponse($name, $data);
    }
}

if (!function_exists('failed_responses')) {
    function failed_responses($data = [])
    {
        return resolve(ResponseHelper::class)->failedResponse($data);
    }
}

if (!function_exists('status_response')) {
    function status_response($name, $status, $data = [])
    {
        return resolve(ResponseHelper::class)->statusResponse($name, $status, $data);
    }
}

if (!function_exists('invited_responses')) {
    function invited_responses($name, $data = [])
    {
        return resolve(ResponseHelper::class)->invitedResponse($name, $data);
    }
}

if (!function_exists('send_reset_link')) {
    function send_reset_link($name, $data = [])
    {
        return resolve(ResponseHelper::class)->resetPasswordResponse($name, $data);
    }
}

if (!function_exists('success_response')) {
    function success_response($message = '', $data = null, $code = 200): \Illuminate\Http\JsonResponse
    {
        return response()->json([
            'status' => true,
            'message' => $message,
            'result' => $data,
        ], $code);
    }
}
    if (!function_exists('error_response')) {
        function error_response($message = '', $data = null, $code = 400): \Illuminate\Http\JsonResponse
        {
            return response()->json([
                'status' => false,
                'message' => $message,
                'result' => $data,
            ], $code);
        }
    }

