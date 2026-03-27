<?php

namespace App\Http\Requests\Core\User;

use Illuminate\Foundation\Http\FormRequest;

class UserProfileThumbnailRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }


    public function rules(): array
    {
        return [
            'profile_picture' => 'required|mimes:jpeg,jpg,png|max:1024',
        ];
    }

    public function messages(): array
    {
        return [
            'profile_picture.mimes' => 'Only jpeg,png,jpg,gif,svg images are allowed',
            'profile_picture.max' => 'Sorry! Maximum allowed size for an image is 1MB'
        ];
    }
}
