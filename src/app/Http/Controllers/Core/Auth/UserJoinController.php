<?php

namespace App\Http\Controllers\Core\Auth;

use App\Exceptions\GeneralException;
use App\Helpers\Core\Notification\NotificationHelper;
use App\Http\Controllers\Controller;
use App\Http\Requests\Core\User\UserJoinRequest;
use App\Models\User;
use App\Notifications\Core\User\UserJoinNotification;
use App\Repositories\Core\StatusRepository;
use Illuminate\Validation\ValidationException;

class UserJoinController extends Controller
{

    /**
     * @throws ValidationException
     * @throws \Throwable
     */
    public function join(UserJoinRequest $request)
    {

        $user = User::query()
            ->where('invitation_token', $request->get('token'))
            ->first();

        throw_if(
            $user && optional($user->status)->name != 'status_invited',
            new GeneralException(__('default.action_not_allowed'))
        );

        $attributes = array_merge($request->only('first_name', 'last_name', 'password'),
            ['status_id' => resolve(StatusRepository::class)->userActive()]
        );

        $user->fill($attributes)
            ->save();

        NotificationHelper::new()
            ->on('user_joined')
            ->with($user)
            ->send(UserJoinNotification::class);

        return response()->json([
            'message' => __('default.user_join_has_been_successfully')
        ]);
    }
}
