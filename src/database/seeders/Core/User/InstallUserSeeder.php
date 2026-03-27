<?php

namespace Database\Seeders\Core\User;

use App\Models\Core\Status\Status;
use App\Models\User;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class InstallUserSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();
        User::query()->truncate();

        User::query()->create([
            'first_name' => 'John',
            'last_name' => 'Doe',
            'email' => 'admin@demo.com',
            'password' => 123456,
            'status_id' => Status::findByNameAndType('status_active', 'user')->id,
            'is_admin' => 1
        ]);

        $this->enableForeignKeys();
    }
}
