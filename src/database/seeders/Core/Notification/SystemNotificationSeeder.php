<?php

namespace Database\Seeders\Core\Notification;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class SystemNotificationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        for ($i = 0; $i < 20; $i++) {
            $message = 'New user has joined Random ' . $i;
            DB::table('notifications')->insert([
                'id' => Str::uuid(),
                'type' => 'App\Notifications\Core\User\UserJoinNotification',
                'notifiable_type' => 'App\Models\User',
                'notifiable_id' => 1,
                'data' => json_encode([
                    'message' => $message
                ]),
                'read_at' => null,
                'created_at' => now(),
                'updated_at' => now()
            ]);
        }
    }
}
