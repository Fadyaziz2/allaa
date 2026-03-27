<?php

namespace Database\Seeders\Invoice\Role;

use App\Models\Core\Permission\Permission;
use App\Models\Core\Role\Role;
use Illuminate\Database\Seeder;

class RolePermissionSeeder extends Seeder
{


    public function run(): void
    {
        $customerRole = Role::query()->where('alias', 'customer')->first();

        $customerPermissions = Permission::query()
            ->whereIn('name', [
                'manage_dashboard',
                'dashboard_statistics_view',
                'view_invoices',
                'invoice_view_recurring',
                'customer_due_invoice_payment',
                'download_invoice',
                'thermal_invoice',
                'download_thermal_invoice',
                'details_view_customer',
                'view_estimates',
                'download_estimate',
                'thermal_estimate',
                'download_thermal_estimate',
                'view_transactions',
                'payment_report_view',
                'transaction_report_view',
                'status_change_estimate'
            ])->get();

        $customer = [];

        foreach ($customerPermissions as $permission) {
            $customer[] = [
                'permission_id' => $permission->id
            ];
        }
        $customerRole->permissions()->sync($customer);


    }
}
