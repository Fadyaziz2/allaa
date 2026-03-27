<?php

namespace App\Http\Controllers\Core\Auth;

use App\Exceptions\GeneralException;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Core\Setting\EmailDeliveryCheckController;
use App\Http\Requests\Core\Auth\PasswordRequest;
use App\Mail\Core\User\ForgetPasswordMail;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class PasswordResetController extends Controller
{

    /**
     * @throws ValidationException
     */
    public function store(PasswordRequest $request): \Illuminate\Foundation\Application|\Illuminate\Http\Response|\Illuminate\Http\JsonResponse|\Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\Routing\ResponseFactory
    {
        $checkEmailSetup = resolve(EmailDeliveryCheckController::class)->isExists();

        if (!$checkEmailSetup) {
            return response([
                'status' => false,
                'message' => trans('default.first_your_email_setup')
            ], 403);
        }

        $user = User::query()
            ->where('email', $request->email)
            ->first();

        $checkEmail = DB::table('password_reset_tokens')
            ->where('email', $request->email)
            ->first();

        $token = Str::random(60) . microtime();

        if ($checkEmail) {
            DB::table('password_reset_tokens')
                ->where('email', $request->email)
                ->update([
                    'token' => $token,
                    'created_at' => Carbon::now()
                ]);
        } else {
            DB::table('password_reset_tokens')->insert([
                'email' => $request->email,
                'token' => $token,
                'created_at' => Carbon::now()
            ]);
        }


        Mail::to($user->email)->send((new ForgetPasswordMail($user, $token))
            ->onQueue('high-priority'));

        return response()->json([
            'status' => true,
            'message' => __('default.reset_link_sent_has_been_successfully')
        ]);

    }

    /**
     * @throws \Throwable
     */
    public function confirmPassword(Request $request)
    {

        $request->validate([
            'token' => 'required|string',
            'password' => 'required|min:6|regex:/^(?=[^\d]*\d)(?=[A-Z\d ]*[^A-Z\d ]).{8,}$/i',
            'password_confirmation' => 'required|same:password|min:6'
        ], [
            'password.regex' => __('default.password_user_gide_message')
        ]);

        $verifyToken = DB::table('password_reset_tokens')
            ->where('token', $request->get('token'))
            ->first();

        throw_if(!($verifyToken), new GeneralException(trans('default.invalid_token')));

        if (Carbon::parse($verifyToken->created_at)->diffInMinutes(Carbon::now()) >= 15) {
            throw_if(!($verifyToken), new GeneralException(trans('default.token_expire')));
        }

        User::query()
            ->where('email', $verifyToken->email)
            ->update(['password' => Hash::make($request->get('password'))]);

        DB::table('password_reset_tokens')
            ->where('token', $verifyToken->token)
            ->delete();

        return updated_responses('password');

    }
}
