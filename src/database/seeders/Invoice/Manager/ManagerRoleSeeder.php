<?php

namespace Database\Seeders\Invoice\Manager;

use App\Models\Core\Permission\Permission;
use App\Models\Core\Role\Role;
use App\Models\Core\Setting\Setting;
use App\Models\Core\Status\Status;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ManagerRoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $role = Role::query()->create([
            'name' => 'Manager',
            'alias' => null,
            'is_admin' => 0,
            'created_by' => 1,
            'is_default' => 1
        ]);

        $managerPermissions = Permission::query()
            ->get();

        $permissions = [];

        foreach ($managerPermissions as $permission) {
            $permissions[] = [
                'permission_id' => $permission->id
            ];
        }

        $role->permissions()->sync($permissions);


        $user = User::query()->create([
            'first_name' => 'Manager',
            'last_name' => 'User',
            'email' => 'manager@demo.com',
            'password' => 123456,
            'status_id' => Status::findByNameAndType('status_active', 'user')->id,
            'is_admin' => 0
        ]);

        $user->roles()->attach($role->id);

        // Email Setting

        Setting::query()->insert(
            [
                ['name' => 'from_name', 'value' => 'InvoiceX', 'settingable_type' => null, 'settingable_id' => null, 'context' => 'default_mail_email_name'],
                ['name' => 'from_email', 'value' => 'invoiceX@theme29.com', 'settingable_type' => null, 'settingable_id' => null, 'context' => 'default_mail_email_name'],
                ['name' => 'provider', 'value' => 'sendmail', 'settingable_type' => null, 'settingable_id' => null, 'context' => 'sendmail'],
                ['name' => 'default_mail', 'value' => 'sendmail', 'settingable_type' => null, 'settingable_id' => null, 'context' => 'mail'],
            ]
        );


    }
}
