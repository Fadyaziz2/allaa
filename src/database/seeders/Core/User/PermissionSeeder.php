<?php

namespace Database\Seeders\Core\User;

use App\Models\Core\Permission\Permission;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class PermissionSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();
        Permission::query()->truncate();

        $permissions = [
            [
                'name' => 'manage_global_access',
                'group_name' => 'global',
            ],
            [
                'name' => 'manage_dashboard',
                'group_name' => 'dashboard',
            ],
            [
                'name' => 'dashboard_statistics_view',
                'group_name' => 'dashboard',
            ],
            [
                'name' => 'income_overview_dashboard',
                'group_name' => 'dashboard',
            ],
            [
                'name' => 'payment_overview_dashboard',
                'group_name' => 'dashboard',
            ],
            [
                'name' => 'expense_overview_dashboard',
                'group_name' => 'dashboard',
            ],
            [
                'name' => 'recent_invoice_dashboard',
                'group_name' => 'dashboard',
            ],
            [
                'name' => 'recent_estimate_dashboard',
                'group_name' => 'dashboard',
            ],
            [
                'name' => 'recent_transaction_dashboard',
                'group_name' => 'dashboard',
            ], [
                'name' => 'recent_expense_dashboard',
                'group_name' => 'dashboard',
            ],

            // Invoice Seeder


            [
                'name' => 'view_customers',
                'group_name' => 'customers',
            ],
            [
                'name' => 'create_customers',
                'group_name' => 'customers',
            ],
            [
                'name' => 'update_customers',
                'group_name' => 'customers',
            ],
            [
                'name' => 'delete_customers',
                'group_name' => 'customers',
            ],
            [
                'name' => 'details_view_customer',
                'group_name' => 'customers',
            ], [
                'name' => 'customer_resend_portal_access',
                'group_name' => 'customers',
            ],

            // Invoice
            [
                'name' => 'view_invoices',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'create_invoices',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'update_invoices',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'delete_invoices',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'due_payment_invoice',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'customer_due_invoice_payment',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'send_attachment_invoice',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'manage_invoice_clone',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'invoice_view_recurring',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'download_invoice',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'thermal_invoice',
                'group_name' => 'invoices',
            ],
            [
                'name' => 'download_thermal_invoice',
                'group_name' => 'invoices',
            ],
            // Estimate
            [
                'name' => 'view_estimates',
                'group_name' => 'Quotations',
            ],
            [
                'name' => 'create_estimates',
                'group_name' => 'Quotations',
            ],
            [
                'name' => 'update_estimates',
                'group_name' => 'Quotations',
            ],
            [
                'name' => 'delete_estimates',
                'group_name' => 'Quotations',
            ],
            [
                'name' => 'resend_mail_estimate',
                'group_name' => 'Quotations',
            ],
            [
                'name' => 'download_estimate',
                'group_name' => 'Quotations',
            ],
            [
                'name' => 'thermal_estimate',
                'group_name' => 'Quotations',
            ],
            [
                'name' => 'download_thermal_estimate',
                'group_name' => 'Quotations',
            ],
            [
                'name' => 'status_change_estimate',
                'group_name' => 'Quotations',
            ], [
                'name' => 'invoice_convert_estimate',
                'group_name' => 'Quotations',
            ],

            // transactions

            [
                'name' => 'view_transactions',
                'group_name' => 'transactions',
            ],


            // Products Modules
            [
                'name' => 'view_categories',
                'group_name' => 'categories',
            ],
            [
                'name' => 'create_categories',
                'group_name' => 'categories',
            ],
            [
                'name' => 'update_categories',
                'group_name' => 'categories',
            ],
            [
                'name' => 'delete_categories',
                'group_name' => 'categories',
            ],

            [
                'name' => 'view_units',
                'group_name' => 'units',
            ],
            [
                'name' => 'create_units',
                'group_name' => 'units',
            ],
            [
                'name' => 'update_units',
                'group_name' => 'units',
            ],
            [
                'name' => 'delete_units',
                'group_name' => 'units',
            ],
            [
                'name' => 'view_products',
                'group_name' => 'products',
            ],
            [
                'name' => 'create_products',
                'group_name' => 'products',
            ],
            [
                'name' => 'update_products',
                'group_name' => 'products',
            ],
            [
                'name' => 'delete_products',
                'group_name' => 'products',
            ],

            //Expense Module
            [
                'name' => 'view_expenses',
                'group_name' => 'expenses',
            ],
            [
                'name' => 'create_expenses',
                'group_name' => 'expenses',
            ],
            [
                'name' => 'update_expenses',
                'group_name' => 'expenses',
            ],
            [
                'name' => 'delete_expenses',
                'group_name' => 'expenses',
            ],

            // Reports Module

            [
                'name' => 'payment_report_view',
                'group_name' => 'reports',
            ],
            [
                'name' => 'transaction_report_view',
                'group_name' => 'reports',
            ],
            [
                'name' => 'expense_report_view',
                'group_name' => 'reports',
            ],
            [
                'name' => 'income_report_view',
                'group_name' => 'reports',
            ],


            // Invoice Settings Module
            ['name' => 'view_taxes',
                'group_name' => 'taxes',
            ],
            [
                'name' => 'create_taxes',
                'group_name' => 'taxes',
            ],
            [
                'name' => 'update_taxes',
                'group_name' => 'taxes',
            ],
            [
                'name' => 'delete_taxes',
                'group_name' => 'taxes',
            ],
            [
                'name' => 'view_notes',
                'group_name' => 'notes',
            ],
            [
                'name' => 'create_notes',
                'group_name' => 'notes',
            ],
            [
                'name' => 'update_notes',
                'group_name' => 'notes',
            ],
            [
                'name' => 'delete_notes',
                'group_name' => 'notes',
            ],
            [
                'name' => 'view_payment_methods',
                'group_name' => 'payment methods',
            ],
            [
                'name' => 'create_payment_methods',
                'group_name' => 'payment methods',
            ],
            [
                'name' => 'update_payment_methods',
                'group_name' => 'payment methods',
            ],
            [
                'name' => 'delete_payment_methods',
                'group_name' => 'payment methods',
            ],
            [
                'name' => 'customizations_view',
                'group_name' => 'customizations',
            ],
            [
                'name' => 'invoice_setting_update',
                'group_name' => 'customizations',
            ],
            [
                'name' => 'estimate_setting_update',
                'group_name' => 'customizations',
            ],
            [
                'name' => 'payment_setting_update',
                'group_name' => 'customizations',
            ],


            //Users
            [
                'name' => 'view_users',
                'group_name' => 'users',
            ],
            [
                'name' => 'update_users',
                'group_name' => 'users',
            ],
            [
                'name' => 'delete_users',
                'group_name' => 'users',
            ],

            [
                'name' => 'manage_user_invite',
                'group_name' => 'users',
            ],

            //Roles
            [
                'name' => 'view_roles',
                'group_name' => 'roles',
            ],
            [
                'name' => 'create_roles',
                'group_name' => 'roles',
            ],
            [
                'name' => 'update_roles',
                'group_name' => 'roles',
            ],
            [
                'name' => 'delete_roles',
                'group_name' => 'roles',
            ],
            [
                'name' => 'attach_user_role',
                'group_name' => 'roles',
            ],
            [
                'name' => 'detach_user_role',
                'group_name' => 'roles',
            ],

            // Notifications

            [
                'name' => 'view_notification_type',
                'group_name' => 'settings',
            ],
            [
                'name' => 'update_notification_template',
                'group_name' => 'settings',
            ],


            //Settings
            [
                'name' => 'view_setting',
                'group_name' => 'settings',
            ],
            [
                'name' => 'view_general_setting',
                'group_name' => 'settings',
            ],
            [
                'name' => 'update_setting',
                'group_name' => 'settings',
            ],
            [
                'name' => 'view_email_setting',
                'group_name' => 'settings',
            ],
            [
                'name' => 'update_email_setting',
                'group_name' => 'settings',
            ],
            [
                'name' => 'view_cronjob',
                'group_name' => 'settings',
            ],
            [
                'name' => 'check_verify_update',
                'group_name' => 'settings',
            ],

            // Import Permission
            [
                'name' => 'product_import',
                'group_name' => 'imports',
            ],
            [
                'name' => 'expense_import',
                'group_name' => 'imports',
            ],

            // Export

            [
                'name' => 'customer_export',
                'group_name' => 'exports',
            ],
            [
                'name' => 'product_export',
                'group_name' => 'exports',
            ],
            [
                'name' => 'expense_export',
                'group_name' => 'exports',
            ],
            [
                'name' => 'payment_export',
                'group_name' => 'exports',
            ],

        ];


        Permission::query()->insert($permissions);
        $this->enableForeignKeys();

    }
}
