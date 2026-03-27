<?php

namespace App\Http\Controllers\Mobile\Api\Administrator;

use App\Exceptions\GeneralException;
use App\Filters\Core\User\UserFilter;
use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Administrator\UserResourceCollection;
use App\Models\Core\Status\Status;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function __construct(UserFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index(): \Illuminate\Http\JsonResponse
    {
        $users = User::query()
            ->filter($this->filter)
            ->with(['profilePicture', 'status:id,name,class', 'role'])
            ->where(function (Builder $builder) {
                $builder->whereHas('roles', fn($query) => $query->whereNull('alias'))
                    ->orWhereDoesntHave('roles');
            })
            ->latest()
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new UserResourceCollection($users));
    }


    public function update(Request $request, User $user): \Illuminate\Http\JsonResponse
    {
        if ($user->is_admin || $user->id == auth()->id()) {
            return error_response(trans('default.action_not_allowed'));
        }

        $user->update([
            'status_id' => Status::findByNameAndType($request->status_name)->id
        ]);

        return success_response('User updated successfully');
    }


    public function destroy(User $user): \Illuminate\Http\JsonResponse
    {
        if ($user->is_admin) {
            return error_response(trans('default.action_not_allowed'));
        }

        if ($user->id == auth()->id()) {
            return error_response(trans('default.cant_delete_own_account'));
        }

        $user->delete();

        return success_response('User deleted successfully');
    }
}
