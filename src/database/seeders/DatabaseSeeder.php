<?php

namespace Database\Seeders;


use App\Models\Invoice\Category\Category;
use App\Models\Invoice\Expense\Expense;
use App\Models\Invoice\Product\Product;
use App\Models\Invoice\Unit\Unit;
use Database\Seeders\Core\Notification\NotificationAudienceSeeder;
use Database\Seeders\Core\Notification\NotificationTemplateSeeder;
use Database\Seeders\Core\Notification\NotificationTypeSeeder;
use Database\Seeders\Core\Notification\SystemNotificationSeeder;
use Database\Seeders\Core\Setting\SettingSeeder;
use Database\Seeders\Core\Status\StatusSeeder;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Database\Seeders\Core\Traits\TruncateTable;
use Database\Seeders\Core\User\PermissionSeeder;
use Database\Seeders\Core\User\RoleSeeder;
use Database\Seeders\Core\User\RoleUserSeeder;
use Database\Seeders\Core\User\UserSeeder;
use Database\Seeders\Invoice\Country\CountrySeder;
use Database\Seeders\Invoice\Estimate\EstimateSeeder;
use Database\Seeders\Invoice\Invoice\InvoiceSeeder;
use Database\Seeders\Invoice\Manager\ManagerRoleSeeder;
use Database\Seeders\Invoice\Note\NoteSeeder;
use Database\Seeders\Invoice\PaymentMethod\PaymentMethodSeeder;
use Database\Seeders\Invoice\Recurring\RecurringCycleSeeder;
use Database\Seeders\Invoice\Role\RolePermissionSeeder;
use Database\Seeders\Invoice\Setting\CustomizationSettingSeeder;
use Database\Seeders\Invoice\Tax\TaxSeeder;
use Database\Seeders\Invoice\Transaction\TransactionSeeder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use TruncateTable, DisableForeignKeys;

    public function run(): void
    {


        Model::unguard();
        $this->disableForeignKeys();
        Category::factory()->count(10)->create();
        Unit::factory()->count(10)->create();
        Product::factory()->count(10)->create();
        Expense::factory()->count(100)->create();

        $this->call([
            SettingSeeder::class,
            StatusSeeder::class,
            UserSeeder::class,
            PermissionSeeder::class,
            RoleSeeder::class,
            RoleUserSeeder::class,
            NotificationTypeSeeder::class,
            NotificationTemplateSeeder::class,
            NotificationAudienceSeeder::class,
            CountrySeder::class,
            RecurringCycleSeeder::class,
            CustomizationSettingSeeder::class,
            RolePermissionSeeder::class,
            TaxSeeder::class,
            PaymentMethodSeeder::class,
            NoteSeeder::class,
            EstimateSeeder::class,
            InvoiceSeeder::class,
            TransactionSeeder::class,
            SystemNotificationSeeder::class,
            ManagerRoleSeeder::class
        ]);



        $this->enableForeignKeys();
        Model::reguard();
    }
}
