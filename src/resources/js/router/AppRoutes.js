import usePermission from "@/core/global/composable/usePermission";

const {canAccess} = usePermission();
export default [
    {
        path: "/",
        name: "admin.invoice",
        component: () => import("@/core/layout/Layout.vue"),
        children: [
            {
                path: "customers",
                name: "customers",
                component: () => import("@/invoice/customer/CustomerList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_customers"),
                },
            },
            {
                path: "products",
                name: "products",
                component: () => import("@/invoice/product/ProductList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_products"),
                },
            },
            {
                path: "categories",
                name: "categories",
                component: () => import("@/invoice/category/CategoryList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_categories"),
                },
            },
            {
                path: "units",
                name: "units",
                component: () => import("@/invoice/unit/UnitList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_units"),
                },
            },
            {
                path: "expenses",
                name: "expenses",
                component: () => import("@/invoice/expense/ExpenseList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_expenses"),
                },
            },
            {
                path: "expense/category",
                name: "expenseCategory",
                component: () =>
                    import("@/invoice/expense/ExpenseCategoryList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_categories"),
                },
            },
            {
                path: "create-invoice",
                name: "createInvoice",
                component: () => import("@/invoice/Invoice/CreateInvoice.vue"),
                meta: {
                    hasPermission: () => canAccess("create_invoices"),
                },
            },
            {
                path: "edit/:id/invoice",
                name: "editInvoice",
                props: true,
                component: () => import("@/invoice/Invoice/UpdateInvoice.vue"),
                meta: {
                    hasPermission: () => canAccess("update_invoices"),
                },
            },
            {
                path: "invoice/:id/details",
                name: "invoiceDetails",
                props: true,
                component: () => import("@/invoice/Invoice/DetailInvoice.vue"),
                // meta: {
                //     hasPermission: () => canAccess("update_invoices"),
                // },
            },
            {
                path: "thermal-invoice/:id",
                name: "thermalInvoice",
                props: true,
                component: () => import("@/invoice/Invoice/ThermalInvoice.vue"),
                meta: {
                    hasPermission: () => canAccess("thermal_invoice"),
                },
            },
            {
                path: "thermal-estimate/:id",
                name: "thermalEstimate",
                props: true,
                component: () => import("@/invoice/estimate/ThermalEstimate.vue"),
                meta: {
                    hasPermission: () => canAccess("thermal_estimate"),
                },
            },
            {
                path: "invoices",
                name: "invoiceList",
                component: () => import("@/invoice/Invoice/InvoiceList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_invoices"),
                },
            },
            {
                path: "recurring-invoices",
                name: "recurringInvoices",
                component: () =>
                    import("@/invoice/Invoice/RecurringInvoiceList.vue"),
                meta: {
                    hasPermission: () => canAccess("invoice_view_recurring"),
                },
            },
            {
                path: "transactions",
                name: "transactions",
                component: () =>
                    import("@/invoice/transaction/TransactionList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_transactions"),
                },
            },
            {
                path: "payment-report",
                name: "paymentReport",
                component: () => import("@/invoice/report/PaymentReport.vue"),
                meta: {
                    hasPermission: () => canAccess("payment_report_view"),
                },
            },
            {
                path: "transaction-report",
                name: "transactionReport",
                component: () =>
                    import("@/invoice/report/TransactionReport.vue"),
                meta: {
                    hasPermission: () => canAccess("transaction_report_view"),
                },
            },
            {
                path: "income-report",
                name: "incomeReport",
                component: () => import("@/invoice/report/IncomeReport.vue"),
                meta: {
                    hasPermission: () => canAccess("income_report_view"),
                },
            },
            {
                path: "expense-report",
                name: "expenseReport",
                component: () => import("@/invoice/report/ExpenseReport.vue"),
                meta: {
                    hasPermission: () => canAccess("expense_report_view"),
                },
            },
            {
                path: "quotations",
                name: "estimates",
                component: () => import("@/invoice/estimate/EstimateList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_estimates"),
                },
            },
            {
                path: "create-quotation",
                name: "CreateEstimates",
                component: () =>
                    import("@/invoice/estimate/EstimateCreate.vue"),
                meta: {
                    hasPermission: () => canAccess("create_estimates"),
                },
            },
            {
                path: "edit/:id/quotation",
                name: "EditEstimates",
                props: true,
                component: () => import("@/invoice/estimate/EstimateUpdate.vue"),
                meta: {
                    hasPermission: () => canAccess("update_estimates"),
                },
            },
            {
                path: "quotation/:id/details",
                name: "estimateDetails",
                props: true,
                component: () => import("@/invoice/estimate/DetailEstimate.vue"),
                // meta: {
                //     hasPermission: () => canAccess("update_invoices"),
                // },
            },
            {
                path: "customer/:id/details",
                name: "customerDetails",
                props: true,
                component: () =>
                    import("@/invoice/customer/CustomerDetails.vue"),
                meta: {
                    hasPermission: () => canAccess("details_view_customer"),
                },
            },
            {
                path: "customizations",
                name: "customizations",
                component: () => import("@/invoice/customization/Index.vue"),
                meta: {
                    hasPermission: () => canAccess("customizations_view"),
                },
            },
            {
                path: "product-import",
                name: "productImport",
                component: () => import("@/invoice/import/ProductImport.vue"),
                meta: {
                    hasPermission: () => canAccess("product_import"),
                },
            },
            {
                path: "expense-import",
                name: "expenseImport",
                component: () => import("@/invoice/import/ExpenseImport.vue"),
                meta: {
                    hasPermission: () => canAccess("expense_import"),
                },
            }
        ],
    },
];
