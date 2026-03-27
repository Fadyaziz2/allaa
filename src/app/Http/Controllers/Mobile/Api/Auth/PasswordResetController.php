<?php

namespace App\Http\Controllers\Mobile\Api\Auth;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Core\Setting\EmailDeliveryCheckController;
use App\Http\Requests\Core\Auth\PasswordRequest;
use App\Mail\Core\User\ForgetPasswordMail;
use App\Mail\Mobile\OtpForgetPasswordMail;
use App\Models\Core\User\UserOtp;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Symfony\Component\Mailer\Exception\TransportException;

class PasswordResetController extends Controller
{
    /**
     * @throws ValidationException
     */
    public function generateOtp(PasswordRequest $request): \Illuminate\Http\JsonResponse
    {
        $checkEmailSetup = resolve(EmailDeliveryCheckController::class)->isExists();

        if (!$checkEmailSetup) {
            return error_response('Email setup does not exist');
        }

        try {
            $user = User::query()
                ->where('email', $request->email)
                ->first();

            $optNumberGenerated = rand(100000, 999999);

            UserOtp::query()->updateOrCreate([
                'user_id' => $user->id,
            ], [
                'otp' => $optNumberGenerated,
                'expire_at' => Carbon::now()->addMinutes(10)
            ]);


            Mail::to($user->email)->send((new OtpForgetPasswordMail($user, $optNumberGenerated))
                ->onQueue('high-priority'));

            return success_response('Otp send successfully', [
                'email' => $user->email
            ]);
        } catch (TransportException $exception) {
            return error_response(trans('default.email_setup_is_not_correct'));
        } catch (\Exception $exception) {
            if (app()->environment('production')) {
                return error_response('Otp send failed. Please try again later');
            }
            return error_response($exception->getMessage());
        }
    }

    public function verifyOtp(Request $request): \Illuminate\Http\JsonResponse
    {
        $request->validate([
            'email' => 'required|email',
            'otp_number' => 'required|min:6|max:6',
        ]);

        $user = $this->getUser($request->email);

        if ($user) {
            $verificationCode = $this->getUserOtp($request, $user);

            if (!$verificationCode) {
                return error_response('You entered wrong verification code', [], 422);
            } elseif (Carbon::parse($verificationCode->expire_at)->diffInMinutes(Carbon::now()) >= 10) {
                return error_response('Verification code has been expired', [], 422);
            } else {
                return success_response('Otp verified successfully', [
                    'email' => $user->email,
                    'otp_number' => $verificationCode->otp
                ]);
            }
        }
        return error_response(trans('default.user_not_found'), 404);
    }

    public function confirmPassword(Request $request): \Illuminate\Http\JsonResponse
    {
        $request->validate([
            'email' => 'required|email',
            'otp_number' => 'required|min:6|max:6',
            'password' => 'required|min:8|regex:/^(?=[^\d]*\d)(?=[A-Z\d ]*[^A-Z\d ]).{8,}$/i',
            'password_confirmation' => 'required|same:password|min:8'
        ], [
            'password.regex' => __('default.password_user_gide_message')
        ]);

        $user = User::query()
            ->where('email', $request->email)
            ->whereHas('otpNumber', fn($query) => $query->where('otp', $request->otp_number))
            ->first();

        if ($user) {
            $user->update(['password' => $request->get('password')]);
            return success_response("Password changed successfully");
        }

        return error_response(trans('default.user_not_found'), 404);
    }

    private function getUser($email): null|object
    {
        return User::query()->where('email', $email)->first();
    }

    private function getUserOtp(Request $request, $user): null|object
    {
        return UserOtp::query()
            ->where('user_id', $user->id)
            ->where('otp', $request->otp_number)
            ->first();
    }
}
