<?php

namespace Database\Seeders\Core\Setting;

use App\Models\Core\Setting\Setting;
use Illuminate\Database\Seeder;

class SettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Setting::query()->insert(
            config('settings.app')
        );
    }
}
