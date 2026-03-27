<?php

namespace App\Http\Controllers\Core\Selectable;

use App\Filters\Core\Role\RoleFilter;
use App\Filters\Core\User\UserFilter;
use App\Http\Controllers\Controller;
use App\Models\Core\Notification\NotificationType;
use App\Models\Core\Role\Role;
use App\Models\User;
use App\Repositories\Core\StatusRepository;
use Illuminate\Database\Eloquent\Builder;

class CoreSelectableController extends Controller
{
    public function roles()
    {
        if ($response = check_permission(['manage_user_invite', 'manage_global_access'])) {
            return $response;
        }

        return Role::query()
            ->whereNull('alias')
            ->filter(new RoleFilter())
            ->select('id', 'name')
            ->paginate(request('per_page', 10));
    }

    public function roleWithoutUser()
    {
        if ($response = check_permission(['attach_user_role', 'detach_user_role', 'manage_global_access'])) {
            return $response;
        }

        $existingUsers = request()->has('existing') ? explode(',', request()->existing) : [];

        return User::query()
            ->filter(new UserFilter())
            ->where([
                ['status_id', resolve(StatusRepository::class)->userActive()],
                ['is_admin', '<>', 1],
                ['id', '<>', auth()->id()]
            ])
            ->where(function (Builder $builder){
                $builder->whereHas('roles', fn ($query) => $query->whereNull('alias'))
                    ->orWhereDoesntHave('roles');
            })
            ->whereNotIn('id', $existingUsers)
            ->select('id', 'first_name', 'last_name')
            ->when(!count($existingUsers), function (Builder $builder) {
                $builder->whereHas('status', function (Builder $builder) {
                    $builder->where('name', '!=', 'status_invited');
                });
            })
            ->paginate(request('per_page', 10));
    }

    public function notificationTemplate(NotificationType $notificationType)
    {
        return $notificationType->load('notificationTemplates')->notificationTemplates;
    }
}
