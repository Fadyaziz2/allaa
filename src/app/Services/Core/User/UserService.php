<?php

namespace App\Services\Core\User;

use App\Mail\Core\User\UserInvitationMail;
use App\Models\User;
use App\Repositories\Core\StatusRepository;
use App\Services\BaseService;
use App\Services\Traits\HasWhen;
use Illuminate\Support\Facades\Mail;

class UserService extends BaseService
{
    use HasWhen;

    public function __construct(User $user)
    {
        $this->model = $user;
    }

    public function invite(): static
    {
        $this->model->fill(array_merge([
            'email' => request()->get('email')
        ], [
                'status_id' => resolve(StatusRepository::class)->userInvited(),
                'invitation_token' => base64_encode(request()->get('email') . '-invitation-from-token'),
            ]
        ))->save();

        return $this;
    }

    public function assignRole(): static
    {
        $this->model->roles()->attach(request()->get('role'));

        return $this;
    }

    public function sendInvitationMail()
    {
        Mail::to(optional($this->model)->email)
            ->send(new UserInvitationMail($this->model));
    }

}
