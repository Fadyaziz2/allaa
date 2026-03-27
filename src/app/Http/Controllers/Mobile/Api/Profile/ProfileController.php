<?php

namespace App\Http\Controllers\Mobile\Api\Profile;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Traits\FileHandler;
use App\Http\Resources\Mobile\Profile\ProfileResource;
use App\Models\Core\User\UserProfile;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class ProfileController extends Controller
{
    use FileHandler;

    public function profile(): \Illuminate\Http\JsonResponse
    {
        $user = auth()->user()->load('userProfile', 'profilePicture');

        return success_response('Data fetched successfully', new ProfileResource($user));
    }

    public function update(Request $request): \Illuminate\Http\JsonResponse
    {
        $request->validate([
            'first_name' => ['required', 'string', 'max:50'],
            'last_name' => ['required', 'string', 'max:30'],
            'email' => ['required', 'email', Rule::unique('users')->ignore(auth()->user())],
            'phone_number' => ['required_with:phone_country'],
            'phone_country' => ['required_with:phone_number'],
            'gender' => ['required', 'in:male,female,others'],
            'address' => ['nullable', 'min:5', 'max:250'],
            'date_of_birth' => ['nullable', 'date'],
            'profile_picture' => ['nullable', 'image', 'mimes:jpeg,png,jpg,gif,svg', 'max:1024'],
        ]);

        try {
            DB::beginTransaction();

            $user = auth()->user();
            $user->update(
                $request->only('first_name', 'last_name', 'email')
            );

            UserProfile::query()->updateOrCreate([
                'user_id' => auth()->id()
            ], array_merge(
                ['user_id' => auth()->id()],
                $request->only('phone_number', 'phone_country', 'address', 'gender', 'date_of_birth')
            ));

            if ($request->hasFile('profile_picture')) {
                $this->deleteImage(optional($user->profilePicture)->path);

                $filePath = $this->uploadImage(
                    request()->file('profile_picture'),
                    'profilePicture'
                );

                $user->profilePicture()->updateOrCreate([
                    'type' => 'profile_picture'
                ], [
                    'path' => $filePath
                ]);
            }

            DB::commit();
            return success_response('Profile updated successfully');
        } catch (Exception $exception) {
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response('Profile update failed');
            }
            return error_response($exception->getMessage());
        }

    }
}
