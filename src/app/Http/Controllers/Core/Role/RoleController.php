<?php

namespace App\Http\Controllers\Core\Role;

use App\Exceptions\GeneralException;
use App\Filters\Core\Role\RoleFilter;
use App\Http\Controllers\Controller;
use App\Http\Requests\Core\Role\RoleRequest;
use App\Models\Core\Role\Role;

class RoleController extends Controller
{
    public function __construct(RoleFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index(): object
    {
        return Role::query()
            ->filter($this->filter)
            ->whereNull('alias')
            ->with('users.profilePicture', 'users.status')
            ->withCount('users', 'permissions')
            ->paginate(request('per_page', 10));
    }


    public function store(RoleRequest $request): array
    {
        $role = Role::query()->create($request->only('name'));

        if ($request->get('permissions'))
            $role->permissions()->sync($request->get('permissions'));

        return created_responses('role');
    }


    public function show(Role $role): Role
    {
        return $role->load('permissions', 'users');
    }


    public function update(RoleRequest $request, Role $role)
    {
        $role->update($request->all());

        if (!($role->is_admin || $role->is_default)) {
            $permission = $request->get('permissions');
            if (empty($permission)) {
                $role->permissions()->detach();
            }
            $role->permissions()->sync($permission);
        }

        return updated_responses('role');
    }


    /**
     * @throws GeneralException
     */
    public function destroy(Role $role): array
    {
        if ($role->is_admin || $role->is_default) {
            throw new GeneralException(trans('default.action_not_allowed'));
        }
        $role->delete();
        return deleted_responses('role');
    }
}
