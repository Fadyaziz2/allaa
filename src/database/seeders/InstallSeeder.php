<?php

namespace Database\Seeders;

use Database\Seeders\Core\Notification\NotificationAudienceSeeder;
use Database\Seeders\Core\Notification\NotificationTemplateSeeder;
use Database\Seeders\Core\Notification\NotificationTypeSeeder;
use Database\Seeders\Core\Setting\SettingSeeder;
use Database\Seeders\Core\Status\StatusSeeder;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Database\Seeders\Core\Traits\TruncateTable;
use Database\Seeders\Core\User\InstallRoleUserSeeder;
use Database\Seeders\Core\User\InstallUserSeeder;
use Database\Seeders\Core\User\PermissionSeeder;
use Database\Seeders\Core\User\RoleSeeder;
use Database\Seeders\Invoice\Country\CountrySeder;
use Database\Seeders\Invoice\Recurring\RecurringCycleSeeder;
use Database\Seeders\Invoice\Role\RolePermissionSeeder;
use Database\Seeders\Invoice\Setting\InstallCustomizationSeeder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Seeder;

class InstallSeeder extends Seeder
{
    use TruncateTable, DisableForeignKeys;

    public function run(): void
    {
        Model::unguard();
        $this->disableForeignKeys();
        $this->call([
            SettingSeeder::class,
            StatusSeeder::class,
            InstallUserSeeder::class,
            PermissionSeeder::class,
            RoleSeeder::class,
            InstallRoleUserSeeder::class,
            RolePermissionSeeder::class,
            NotificationTypeSeeder::class,
            NotificationTemplateSeeder::class,
            NotificationAudienceSeeder::class,
            CountrySeder::class,
            RecurringCycleSeeder::class,
            InstallCustomizationSeeder::class,
        ]);
        $this->enableForeignKeys();
        Model::reguard();
    }
}
