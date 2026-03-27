<?php

namespace App\Http\Controllers\Mobile\Api\Administrator;

use App\Exceptions\GeneralException;
use App\Filters\Core\Role\RoleFilter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Core\Role\RoleRequest;
use App\Http\Resources\Mobile\Administrator\RoleResourceCollection;
use App\Models\Core\Role\Role;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RoleController extends Controller
{
    public function __construct(RoleFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index(): JsonResponse
    {
        $roles = Role::query()
            ->filter($this->filter)
            ->whereNull('alias')
            ->with('users.profilePicture', 'users.status')
            ->withCount('users', 'permissions')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new RoleResourceCollection($roles));
    }


    public function store(RoleRequest $request): JsonResponse
    {
        $role = Role::query()->create($request->only('name'));

        if ($request->get('permissions'))
            $role->permissions()->sync($request->get('permissions'));

        return success_response('Data created successfully');
    }


    public function show($id): JsonResponse
    {
        $role = Role::query()
            ->select('id', 'name')
            ->with('permissions:id,name,group_name')
            ->where('id', $id)
            ->first();

        return success_response('Data fetched successfully', $role);
    }


    public function update(RoleRequest $request, Role $role): JsonResponse
    {
        $role->update($request->all());

        if (!($role->is_admin || $role->is_default)) {
            $permission = $request->get('permissions');
            if (empty($permission)) {
                $role->permissions()->detach();
            }
            $role->permissions()->sync($permission);
        }

        return success_response('Data updated successfully');
    }


    public function destroy(Role $role): JsonResponse
    {
        if ($role->is_admin || $role->is_default) {
            return error_response(trans('default.action_not_allowed'));
        }
        $role->delete();

        return success_response('Data deleted successfully');
    }
}
