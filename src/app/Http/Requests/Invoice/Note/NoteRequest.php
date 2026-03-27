<?php

namespace App\Http\Requests\Invoice\Note;

use Illuminate\Foundation\Http\FormRequest;

class NoteRequest extends FormRequest
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
            'type' => ['required', 'in:invoice,payment,estimate'],
            'name' => ['required', 'max:255', 'string'],
            'note' => ['required']
        ];
    }
}
