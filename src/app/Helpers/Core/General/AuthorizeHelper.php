<?php

namespace App\Helpers\Core\General;

use App\Exceptions\AuthorizeException;
use App\Exceptions\GeneralException;
use App\Repositories\Core\UserRepository;

class AuthorizeHelper
{
    public function __construct(protected UserRepository $user)
    {

    }


    /**
     * @throws AuthorizeException
     */
    public function authorize($actions)
    {
        if (is_array($actions)) {

            if (in_array(0, $this->arrayAuthorizer($actions))) {
                throw new AuthorizeException(trans('default.action_not_allowed'));
            }

            return true;
        }

        if (is_string($actions) && auth()->user()->can($actions)) {
            return true;
        }

        throw new AuthorizeException(trans('default.action_not_allowed'));
    }


    public function getAuthorized($action)
    {
        $this->authorize($action);
        $permissions = $this->user->findAuthUserPermission($action);
        if (!empty($permissions['pivot'])) {
            return $permissions['pivot'];
        }
        return [];
    }


    /**
     * @throws AuthorizeException
     */
    public function isAuthorizedSpecific($action, $payload): bool
    {
        $authorized = $this->getAuthorized($action);

        if (count($authorized) > 0) {
            if (!in_array($payload, $authorized)) {
                throw new AuthorizeException(trans('default.action_not_allowed'));
            }
        }

        return true;
    }

    public function authorizeMultiple(array $actions): bool
    {
        return in_array(0, $this->arrayAuthorizer($actions));
    }

    public function authorizeAny(array $actions): bool
    {
        return in_array(1, $this->arrayAuthorizer($actions));
    }

    public function arrayAuthorizer(array $actions): array
    {
        return collect($actions)->map(function ($action) {
            return auth()->user()->can($action) ? 1 : 0;
        })->toArray();
    }
}
