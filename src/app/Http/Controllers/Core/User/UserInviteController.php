<?php

namespace App\Http\Controllers\Core\User;

use App\Exceptions\GeneralException;
use App\Http\Controllers\Controller;
use App\Http\Requests\Core\User\UserInviteRequest;
use App\Services\Core\User\UserService;
use Illuminate\Support\Facades\DB;
use Symfony\Component\Mailer\Exception\TransportException;

class UserInviteController extends Controller
{

    public function __construct(UserService $service)
    {
        $this->service = $service;
    }

    /**
     * @throws GeneralException
     */
    public function invite(UserInviteRequest $request)
    {
        try {
            DB::transaction(function () use ($request) {
                $this->service
                    ->invite()
                    ->when($request->get('role'), fn(UserService $service) => $service->assignRole())
                    ->sendInvitationMail();
            });
            return invited_responses('users');
        } catch (TransportException $exception) {
            DB::rollBack();
            throw new GeneralException(__('default.email_setup_is_not_correct'));
        } catch (\Exception $exception) {
            DB::rollBack();
            throw new GeneralException(__('default.user_invitation_has_been_field'));
        }
    }
}
