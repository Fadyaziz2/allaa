<?php

namespace App\Http\Controllers\Mobile\Api\Auth;

use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Auth\AuthUserResource;
use App\Models\User;
use App\Repositories\Core\StatusRepository;
use App\Repositories\Core\UserRepository;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class LoginController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:api', ['except' => ['login']]);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => ['required', 'email', 'max:100'],
            'password' => ['required', 'string', 'max:50'],
            'device_token' => ['required', 'string', 'max:255'],
        ]);

        try {
            $user = User::query()
                ->where('status_id', resolve(StatusRepository::class)->userActive())
                ->where('email', $request->only('email'))
                ->first();

            if (!$user) {
                return error_response(__('default.user_not_found'), null, 404);
            }
            if (!Hash::check($request->password, $user->password)) {
                return error_response(__('default.incorrect_email_or_password'));
            }

            if ($token = $this->guard()->attempt(array_merge($request->only('password'), ['email' => $user->email]))) {
                $this->saveDeviceToken($user);
                return $this->respondWithToken($token);
            }
        }catch (\Exception $exception){
            return error_response($exception->getMessage());
        }

    }

    public function saveDeviceToken($model): static
    {
        $deviceToken = request()->get('device_token');
        $model->deviceTokens()->updateOrCreate(
            ['token' => $deviceToken], // Find the existing record
            ['token' => $deviceToken]  // Update or create the new record with the same device token
        );
        return $this;
    }


    private function respondWithToken($token): \Illuminate\Http\JsonResponse
    {
        return success_response('Login successfully', [
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => Carbon::now()->addYears()->timestamp,
            'user' => new AuthUserResource(auth()->user()),
            'permissions' => array_merge(
                resolve(UserRepository::class)->getPermissionsForFrontEnd(),
                [
                    'is_app_admin' => auth()->user()->isAppAdmin(),
                    'is_customer' => auth()->user()->isCustomer(),
                ]
            ),
        ]);
    }


    private function guard(): \Illuminate\Contracts\Auth\Guard|\Illuminate\Contracts\Auth\StatefulGuard
    {
        return Auth::guard();
    }
}
