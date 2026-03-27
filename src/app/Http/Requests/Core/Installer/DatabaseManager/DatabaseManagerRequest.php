<?php

namespace App\Http\Requests\Core\Installer\DatabaseManager;

use Illuminate\Foundation\Http\FormRequest;

class DatabaseManagerRequest extends FormRequest
{

    public function authorize(): bool
    {
        return true;
    }


    public function rules()
    {
        return [
            'database_connection' => ['required', 'string', 'in:mysql,pgsql,sqlite,sqlsrv'],
            'database_hostname' => ['required', 'string', 'regex:/^[^#]+$/U'],
            'database_port' => ['required', 'string', 'regex:/^[^#]+$/U'],
            'database_name' => ['required', 'string', 'regex:/^[^#]+$/U'],
            'database_username' => ['required', 'string', 'regex:/^[^#]+$/U'],
            'database_password' => ['required', 'string', 'regex:/^[^#]+$/U'],
        ];
    }

    public function attributes()
    {
        return [
            'database_connection' => 'driver',
        ];
    }
}
