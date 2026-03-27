<?php

namespace App\Http\Controllers\Core\Permission;

use App\Http\Controllers\Controller;
use App\Models\Core\Permission\Permission;

class PermissionController extends Controller
{
    public function index(): \Illuminate\Database\Eloquent\Collection|\Illuminate\Http\JsonResponse|array
    {
        if ($response = check_permission(['create_roles', 'update_roles', 'manage_global_access'])) {
            return $response;
        }
        $permissions = Permission::query()
            ->select('id', 'name', 'group_name')
            ->get()
            ->groupBy('group_name');

        if (request()->is('api/mobile/*')) {
            return success_response('Data fetched successfully.', $permissions);
        }

        return $permissions;
    }
}
