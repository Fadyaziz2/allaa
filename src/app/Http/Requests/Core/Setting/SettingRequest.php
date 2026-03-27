<?php

namespace App\Http\Requests\Core\Setting;

use Illuminate\Foundation\Http\FormRequest;

class SettingRequest extends FormRequest
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
            'company_name' => 'required',
            'language' => 'required',
            'date_format' => 'required',
            'time_format' => 'required',
            'time_zone' => 'required',
            'currency_symbol' => 'required',
            'decimal_separator' => 'required',
            'thousand_separator' => 'required',
            'number_of_decimal' => 'required',
            'currency_position' => 'required',
        ];
    }
}
