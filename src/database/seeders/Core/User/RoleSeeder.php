<?php

namespace Database\Seeders\Core\User;

use App\Models\Core\Role\Role;
use App\Models\User;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        Role::query()->truncate();
        // Create Roles
        $superAdmin = User::first();

        $roles = [
            [
                'name' => config('access.users.app_admin_role'),
                'alias' => null,
                'is_admin' => 1,
                'created_by' => $superAdmin->id,
                'is_default' => 1
            ],
            [
                'name' => 'Customer',
                'alias' => 'customer',
                'is_admin' => 0,
                'created_by' => $superAdmin->id,
                'is_default' => 1
            ],

        ];

        Role::query()->insert($roles);

        $this->enableForeignKeys();
    }
}
