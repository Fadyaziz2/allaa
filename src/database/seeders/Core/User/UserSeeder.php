<?php

namespace Database\Seeders\Core\User;

use App\Models\Core\Status\Status;
use App\Models\Core\User\UserProfile;
use App\Models\User;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        User::query()->create([
            'first_name' => 'John',
            'last_name' => 'Doe',
            'email' => 'admin@demo.com',
            'password' => 123456,
            'status_id' => Status::findByNameAndType('status_active', 'user')->id,
            'is_admin' => 1
        ]);

        User::query()->create([
            'first_name' => 'Fermin',
            'last_name' => 'Prohaska',
            'email' => 'veum.judah@example.net',
            'password' => 123456,
            'status_id' => Status::findByNameAndType('status_active', 'user')->id,
            'is_admin' => 0
        ]);
        User::query()->create([
            'first_name' => 'Wilfred',
            'last_name' => 'Ratke',
            'email' => 'mariela52@example.com',
            'password' => 123456,
            'status_id' => Status::findByNameAndType('status_active', 'user')->id,
            'is_admin' => 0
        ]);
        User::query()->create([
            'first_name' => 'German',
            'last_name' => 'Gerlach',
            'email' => 'gspinka@example.com',
            'password' => 123456,
            'status_id' => Status::findByNameAndType('status_active', 'user')->id,
            'is_admin' => 0
        ]);
        User::query()->create([
            'first_name' => 'Tabitha',
            'last_name' => 'Abernathy',
            'email' => 'kristopher.friesen@example.com',
            'password' => 123456,
            'status_id' => Status::findByNameAndType('status_inactive', 'user')->id,
            'is_admin' => 0
        ]);
        User::query()->create([
            'first_name' => 'Mac',
            'last_name' => 'Tillman',
            'email' => 'pauline03@example.net',
            'password' => 123456,
            'status_id' => Status::findByNameAndType('status_inactive', 'user')->id,
            'is_admin' => 0
        ]);
        User::query()->create([
            'first_name' => 'Customer',
            'last_name' => 'User',
            'email' => 'customer@demo.com',
            'password' => 123456,
            'status_id' => Status::findByNameAndType('status_active', 'user')->id,
            'is_admin' => 0
        ]);

        User::factory()->count(10)->create();
//        User::factory()->count(30)->create()->each(function ($item){
//            UserProfile::factory(30)->create(['user_id' => $item->id]);
//        });

        $this->enableForeignKeys();
    }
}
