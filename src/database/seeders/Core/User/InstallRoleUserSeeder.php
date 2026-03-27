<?php

namespace Database\Seeders\Core\User;

use App\Models\User;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class InstallRoleUserSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();
        $user = User::query()->find(1);
        $user->roles()->attach(1);
        $this->enableForeignKeys();
    }
}
