<?php

namespace App\Http\Controllers\Core\Auth;

use App\Http\Controllers\Controller;
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
            'email' => 'required|email|max:100',
            'password' => 'required|string|max:50',
        ]);

        $user = User::query()
            ->where('status_id', resolve(StatusRepository::class)->userActive())
            ->where('email', $request->only('email'))
            ->first();

        if (!$user) {
            return response()->json([
                'status' => false,
                'message' => __('default.user_not_found'),
            ], 404);
        }
        if (!Hash::check($request->password, $user->password)) {
            return response()->json([
                'status' => false,
                'message' => __('default.incorrect_email_or_password'),
            ], 404);
        }

        if ($token = $this->guard()->attempt(array_merge($request->only('password'), ['email' => $user->email]))) {
            return $this->respondWithToken($token);
        }

    }

    private function respondWithToken($token): \Illuminate\Http\JsonResponse
    {
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => Carbon::now()->addYears()->timestamp,
            'user' => auth()->user(),
            'permissions' => array_merge(
                resolve(UserRepository::class)->getPermissionsForFrontEnd(),
                [
                    'is_app_admin' => auth()->user()->isAppAdmin(),
                ]
            ),
        ]);
    }


    private function guard(): \Illuminate\Contracts\Auth\Guard|\Illuminate\Contracts\Auth\StatefulGuard
    {
        return Auth::guard();
    }
}
