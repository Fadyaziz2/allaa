<?php

namespace Database\Seeders\Core\User;

use App\Models\Core\Role\Role;
use App\Models\User;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class RoleUserSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();
        $user = User::query()->find(1);
        $user->roles()->attach(1);
        $this->enableForeignKeys();

        $users = User::query()
            ->where('is_admin', '<>', 1)
            ->get();

        $role = Role::query()
            ->where('alias', 'customer')
            ->pluck('id')
            ->toArray();

        $users->each(function ($item) use ($role) {
            $item->roles()->attach($role);
        });
    }
}
