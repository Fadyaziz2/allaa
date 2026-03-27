<?php

namespace App\Helpers\Core\General;

class ResponseHelper
{
    public function createdResponse($name, $data = []): array
    {
        return array_merge([
            'status' => true,
            'message' => trans('default.created_response', [
                'name' => trans("default.{$name}")
            ]),
        ], $data);
    }

    public function updatedResponse($name, $data = []): array
    {
        return array_merge([
            'status' => true,
            'message' => trans('default.updated_response', [
                'name' => trans("default.{$name}")
            ]),
        ], $data);
    }

    public function deletedResponse($name, $data = []): array
    {
        return array_merge([
            'status' => true,
            'message' => trans('default.deleted_response', [
                'name' => trans("default.{$name}")
            ]),
        ], $data);
    }

    public function failedResponse($data = []): array
    {
        return array_merge([
            'status' => false,
            'message' => trans('default.failed_response')
        ], $data);
    }

    public function statusResponse($name, $status, $data = []): array
    {
        return array_merge([
            'status' => true,
            'message' => trans('default.status_updated_response', [
                'name' => trans("default.{$name}"),
                'status' => trans("default.{$status}")
            ])
        ], $data);
    }

    public function invitedResponse($name, $data = []): array
    {
        return array_merge([
            'status' => true,
            'message' => trans('default.invited_response', [
                'name' => trans("default.{$name}")
            ]),
        ], $data);
    }


    public function resetPasswordResponse($name, $data = []): array
    {
        return array_merge([
            'status' => true,
            'message' => trans('default.password_reset_response', [
                'name' => trans("default.{$name}")
            ]),
        ], $data);
    }
}
