<?php

namespace App\Http\Controllers\Core\User;

use App\Exceptions\GeneralException;
use App\Filters\Core\User\UserFilter;
use App\Http\Controllers\Controller;
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

    public function index()
    {
        return User::query()
            ->filter($this->filter)
            ->with(['profilePicture', 'status:id,name,class', 'role'])
            ->where(function (Builder $builder){
                $builder->whereHas('roles', fn ($query) => $query->whereNull('alias'))
                    ->orWhereDoesntHave('roles');
            })
            ->latest()
            ->paginate(request('per_page', 10));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     * @throws \Throwable
     */
    public function update(Request $request, User $user)
    {
        throw_if(
            ($user->is_admin || $user->id == auth()->id()),
            new GeneralException(trans('default.action_not_allowed'))
        );

        $user->update([
            'status_id' => Status::findByNameAndType($request->status_name)->id
        ]);

        return updated_responses('users');
    }

    /**
     * Remove the specified resource from storage.
     * @throws GeneralException
     */
    public function destroy(User $user)
    {
        if ($user->is_admin) {
            throw new GeneralException(trans('default.action_not_allowed'));
        }

        if ($user->id == auth()->id()) {
            throw new GeneralException(trans('default.cant_delete_own_account'));
        }
        $user->delete();

        return deleted_responses('users');
    }
}
