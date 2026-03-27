<?php

namespace App\Http\Controllers\Core\User;

use App\Helpers\Core\Traits\FileHandler;
use App\Http\Controllers\Controller;
use App\Http\Requests\Core\User\UserProfileRequest;
use App\Http\Requests\Core\User\UserProfileThumbnailRequest;
use App\Models\Core\User\UserProfile;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class ProfileController extends Controller
{
    use FileHandler;

    public function profile()
    {
        return User::query()
            ->where('id', auth()->id())
            ->with(['userProfile', 'profilePicture'])
            ->first();

    }

    public function update(UserProfileRequest $request)
    {
        if (env('IS_DEMO')){
            return response()->json([
                'status' => true,
                'message' => 'In demo version not available'
            ],403);
        }

        auth()->user()->update(
            $request->only('first_name', 'last_name', 'email')
        );

        UserProfile::query()->updateOrCreate([
            'user_id' => auth()->id()
        ], array_merge(
            ['user_id' => auth()->id()],
            $request->only('phone_number', 'phone_country', 'address', 'gender', 'date_of_birth')
        ));

        return updated_responses('profile');
    }


    public function profileThumbnail(UserProfileThumbnailRequest $request)
    {
        $user = auth()->user();
        $this->deleteImage(optional($user->profilePicture)->path);

        $file_path = $this->uploadImage(
            request()->file('profile_picture'),
            'profilePicture'
        );

        $user->profilePicture()->updateOrCreate([
            'type' => 'profile_picture'
        ], [
            'path' => $file_path
        ]);

        return updated_responses('profile_picture');
    }

    /**
     * @throws ValidationException
     */
    public function passwordChange(Request $request)
    {
        if (env('IS_DEMO')){
            return response()->json([
                'status' => true,
                'message' => 'In demo version not available'
            ],403);
        }

        $this->validate($request, [
            'current_password' => 'required',
            'password' => 'required|min:8|regex:/^(?=[^\d]*\d)(?=[A-Z\d ]*[^A-Z\d ]).{8,}$/i',
                'confirm_password' => 'required_with:password|same:password'
        ],[
            'password.regex' => __('default.password_user_gide_message')
        ]);

        if (Hash::check($request->get('current_password'), auth()->user()->password)) {
            auth()->user()->update([
                'password' => $request->get('password')
            ]);
            return updated_responses('password');
        }

        throw ValidationException::withMessages([
            'current_password' => trans('default.current_password_is_in_correct')
        ]);
    }

}
