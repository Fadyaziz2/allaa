<?php

namespace App\Http\Requests\Core\Role;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class RoleRequest extends FormRequest
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
            'name' => [
                'required',
                'max:50',
                Rule::unique('roles', 'name')->ignore($this->role) // Use Rule::unique to ignore the current role's name during update
            ],
            'permissions' => 'array',
        ];
    }
}
