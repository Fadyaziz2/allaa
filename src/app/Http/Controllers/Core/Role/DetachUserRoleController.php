<?php

namespace App\Http\Controllers\Core\Role;

use App\Exceptions\GeneralException;
use App\Http\Controllers\Controller;
use App\Models\Core\Role\Role;
use App\Models\User;
use Illuminate\Http\Request;

class DetachUserRoleController extends Controller
{

    /**
     * @throws GeneralException
     */
    public function detach(Request $request, User $user): \Illuminate\Http\JsonResponse
    {
        if ($user->is_admin) {
            throw new GeneralException(trans('default.action_not_allowed'));
        }

        if ($user->id == auth()->id()) {
            throw new GeneralException(trans('default.can_not_delete_own_account_role'));
        }
        $user->roles()->detach();

        return response()->json([
            'message' => __('default.user_role_has_been_removed')
        ]);
    }

    /**
     * @throws GeneralException
     */
    public function attach(Request $request, Role $role)
    {

        $this->previousRoleDetach($request);

        $role->users()->attach($request->users);
        return response()->json([
            'message' => __('default.user_role_has_been_attach')
        ]);
    }

    /**
     * @throws GeneralException
     */
    private function previousRoleDetach($request)
    {

        $users = User::query()->whereIn('id', $request->users)->get();

        $checkIsAdmin = $users->filter(fn($user) => $user->is_admin)->first();
        if ($checkIsAdmin) {
            throw new GeneralException(trans('default.supper_admin_user_can_not_downgrade'));
        }

        $checkOwnAccount = $users->filter(fn($user) => $user->id == auth()->id())->first();
        if ($checkOwnAccount) {
            throw new GeneralException(trans('default.can_not_delete_own_account_role'));
        }

        $users->each(function ($item) {
            $item->roles()->detach();
        });
    }
}
