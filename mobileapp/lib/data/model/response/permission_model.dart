class PermissionModel {
  bool? manageGlobalAccess;
  bool? manageDashboard;
  bool? dashboardStatisticsView;
  bool? incomeOverviewDashboard;
  bool? paymentOverviewDashboard;
  bool? expenseOverviewDashboard;
  bool? recentInvoiceDashboard;
  bool? recentEstimateDashboard;
  bool? recentTransactionDashboard;
  bool? recentExpenseDashboard;
  bool? viewCustomers;
  bool? createCustomers;
  bool? updateCustomers;
  bool? deleteCustomers;
  bool? detailsViewCustomer;
  bool? customerResendPortalAccess;
  bool? viewInvoices;
  bool? createInvoices;
  bool? updateInvoices;
  bool? deleteInvoices;
  bool? duePaymentInvoice;
  bool? customerDueInvoicePayment;
  bool? sendAttachmentInvoice;
  bool? manageInvoiceClone;
  bool? invoiceViewRecurring;
  bool? downloadInvoice;
  bool? downloadThermalInvoice;
  bool? downloadThermalEstimate;
  bool? viewEstimates;
  bool? createEstimates;
  bool? updateEstimates;
  bool? deleteEstimates;
  bool? resendMailEstimate;
  bool? downloadEstimate;
  bool? statusChangeEstimate;
  bool? invoiceConvertEstimate;
  bool? viewTransactions;
  bool? viewCategories;
  bool? createCategories;
  bool? updateCategories;
  bool? deleteCategories;
  bool? viewUnits;
  bool? createUnits;
  bool? updateUnits;
  bool? deleteUnits;
  bool? viewProducts;
  bool? createProducts;
  bool? updateProducts;
  bool? deleteProducts;
  bool? viewExpenses;
  bool? createExpenses;
  bool? updateExpenses;
  bool? deleteExpenses;
  bool? paymentReportView;
  bool? transactionReportView;
  bool? expenseReportView;
  bool? incomeReportView;
  bool? viewTaxes;
  bool? createTaxes;
  bool? updateTaxes;
  bool? deleteTaxes;
  bool? viewNotes;
  bool? createNotes;
  bool? updateNotes;
  bool? deleteNotes;
  bool? viewPaymentMethods;
  bool? createPaymentMethods;
  bool? updatePaymentMethods;
  bool? deletePaymentMethods;
  bool? customizationsView;
  bool? invoiceSettingUpdate;
  bool? estimateSettingUpdate;
  bool? paymentSettingUpdate;
  bool? viewUsers;
  bool? updateUsers;
  bool? deleteUsers;
  bool? manageUserInvite;
  bool? viewRoles;
  bool? createRoles;
  bool? updateRoles;
  bool? deleteRoles;
  bool? attachUserRole;
  bool? detachUserRole;
  bool? viewNotificationType;
  bool? updateNotificationTemplate;
  bool? viewSetting;
  bool? viewGeneralSetting;
  bool? updateSetting;
  bool? viewEmailSetting;
  bool? updateEmailSetting;
  bool? viewCronjob;
  bool? checkVerifyUpdate;
  bool? isAppAdmin;
  bool? isCustomer;

  PermissionModel({
    this.manageGlobalAccess,
    this.manageDashboard,
    this.dashboardStatisticsView,
    this.incomeOverviewDashboard,
    this.paymentOverviewDashboard,
    this.expenseOverviewDashboard,
    this.recentInvoiceDashboard,
    this.recentEstimateDashboard,
    this.recentTransactionDashboard,
    this.recentExpenseDashboard,
    this.viewCustomers,
    this.createCustomers,
    this.updateCustomers,
    this.deleteCustomers,
    this.detailsViewCustomer,
    this.customerResendPortalAccess,
    this.viewInvoices,
    this.createInvoices,
    this.updateInvoices,
    this.deleteInvoices,
    this.duePaymentInvoice,
    this.customerDueInvoicePayment,
    this.sendAttachmentInvoice,
    this.manageInvoiceClone,
    this.invoiceViewRecurring,
    this.downloadInvoice,
    this.downloadThermalInvoice,
    this.downloadThermalEstimate,
    this.viewEstimates,
    this.createEstimates,
    this.updateEstimates,
    this.deleteEstimates,
    this.resendMailEstimate,
    this.downloadEstimate,
    this.statusChangeEstimate,
    this.invoiceConvertEstimate,
    this.viewTransactions,
    this.viewCategories,
    this.createCategories,
    this.updateCategories,
    this.deleteCategories,
    this.viewUnits,
    this.createUnits,
    this.updateUnits,
    this.deleteUnits,
    this.viewProducts,
    this.createProducts,
    this.updateProducts,
    this.deleteProducts,
    this.viewExpenses,
    this.createExpenses,
    this.updateExpenses,
    this.deleteExpenses,
    this.paymentReportView,
    this.transactionReportView,
    this.expenseReportView,
    this.incomeReportView,
    this.viewTaxes,
    this.createTaxes,
    this.updateTaxes,
    this.deleteTaxes,
    this.viewNotes,
    this.createNotes,
    this.updateNotes,
    this.deleteNotes,
    this.viewPaymentMethods,
    this.createPaymentMethods,
    this.updatePaymentMethods,
    this.deletePaymentMethods,
    this.customizationsView,
    this.invoiceSettingUpdate,
    this.estimateSettingUpdate,
    this.paymentSettingUpdate,
    this.viewUsers,
    this.updateUsers,
    this.deleteUsers,
    this.manageUserInvite,

    this.viewRoles,
    this.createRoles,
    this.updateRoles,
    this.deleteRoles,
    this.attachUserRole,
    this.detachUserRole,
    this.viewNotificationType,
    this.updateNotificationTemplate,
    this.viewSetting,
    this.viewGeneralSetting,
    this.updateSetting,
    this.viewEmailSetting,
    this.updateEmailSetting,
    this.viewCronjob,
    this.checkVerifyUpdate,
    this.isAppAdmin,
    this.isCustomer,
  });

  PermissionModel.fromJson(Map<String, dynamic> json) {
    manageGlobalAccess = json['manage_global_access'] ?? false;
    manageDashboard = json['manage_dashboard'] ?? false;
    dashboardStatisticsView = json['dashboard_statistics_view'] ?? false;
    incomeOverviewDashboard = json['income_overview_dashboard'] ?? false;
    paymentOverviewDashboard = json['payment_overview_dashboard'] ?? false;
    expenseOverviewDashboard = json['expense_overview_dashboard'] ?? false;
    recentInvoiceDashboard = json['recent_invoice_dashboard'] ?? false;
    recentEstimateDashboard = json['recent_estimate_dashboard'] ?? false;
    recentTransactionDashboard = json['recent_transaction_dashboard'] ?? false;
    recentExpenseDashboard = json['recent_expense_dashboard'] ?? false;
    viewCustomers = json['view_customers'] ?? false;
    createCustomers = json['create_customers'] ?? false;
    updateCustomers = json['update_customers'] ?? false;
    deleteCustomers = json['delete_customers'] ?? false;
    detailsViewCustomer = json['details_view_customer'] ?? false;
    customerResendPortalAccess = json['customer_resend_portal_access'] ?? false;
    viewInvoices = json['view_invoices'] ?? false;
    createInvoices = json['create_invoices'] ?? false;
    updateInvoices = json['update_invoices'] ?? false;
    deleteInvoices = json['delete_invoices'] ?? false;
    duePaymentInvoice = json['due_payment_invoice'] ?? false;
    customerDueInvoicePayment = json['customer_due_invoice_payment'] ?? false;
    sendAttachmentInvoice = json['send_attachment_invoice'] ?? false;
    manageInvoiceClone = json['manage_invoice_clone'] ?? false;
    invoiceViewRecurring = json['invoice_view_recurring'] ?? false;
    downloadInvoice = json['download_invoice'] ?? false;
    downloadThermalInvoice = json['download_thermal_invoice'] ?? false;
    downloadThermalEstimate = json['download_thermal_estimate'] ?? false;
    viewEstimates = json['view_estimates'] ?? false;
    createEstimates = json['create_estimates'] ?? false;
    updateEstimates = json['update_estimates'] ?? false;
    deleteEstimates = json['delete_estimates'] ?? false;
    resendMailEstimate = json['resend_mail_estimate'] ?? false;
    downloadEstimate = json['download_estimate'] ?? false;
    statusChangeEstimate = json['status_change_estimate'] ?? false;
    invoiceConvertEstimate = json['invoice_convert_estimate'] ?? false;
    viewTransactions = json['view_transactions'] ?? false;
    viewCategories = json['view_categories'] ?? false;
    createCategories = json['create_categories'] ?? false;
    updateCategories = json['update_categories'] ?? false;
    deleteCategories = json['delete_categories'] ?? false;
    viewUnits = json['view_units'] ?? false;
    createUnits = json['create_units'] ?? false;
    updateUnits = json['update_units'] ?? false;
    deleteUnits = json['delete_units'] ?? false;
    viewProducts = json['view_products'] ?? false;
    createProducts = json['create_products'] ?? false;
    updateProducts = json['update_products'] ?? false;
    deleteProducts = json['delete_products'] ?? false;
    viewExpenses = json['view_expenses'] ?? false;
    createExpenses = json['create_expenses'] ?? false;
    updateExpenses = json['update_expenses'] ?? false;
    deleteExpenses = json['delete_expenses'] ?? false;
    paymentReportView = json['payment_report_view'] ?? false;
    transactionReportView = json['transaction_report_view'] ?? false;
    expenseReportView = json['expense_report_view'] ?? false;
    incomeReportView = json['income_report_view'] ?? false;
    viewTaxes = json['view_taxes'] ?? false;
    createTaxes = json['create_taxes'] ?? false;
    updateTaxes = json['update_taxes'] ?? false;
    deleteTaxes = json['delete_taxes'] ?? false;
    viewNotes = json['view_notes'] ?? false;
    createNotes = json['create_notes'] ?? false;
    updateNotes = json['update_notes'] ?? false;
    deleteNotes = json['delete_notes'] ?? false;
    viewPaymentMethods = json['view_payment_methods'] ?? false;
    createPaymentMethods = json['create_payment_methods'] ?? false;
    updatePaymentMethods = json['update_payment_methods'] ?? false;
    deletePaymentMethods = json['delete_payment_methods'] ?? false;
    customizationsView = json['customizations_view'] ?? false;
    invoiceSettingUpdate = json['invoice_setting_update'] ?? false;
    estimateSettingUpdate = json['estimate_setting_update'] ?? false;
    paymentSettingUpdate = json['payment_setting_update'] ?? false;
    viewUsers = json['view_users'] ?? false;
    updateUsers = json['update_users'] ?? false;
    deleteUsers = json['delete_users'] ?? false;
    manageUserInvite = json['manage_user_invite'] ?? false;
    viewRoles = json['view_roles'] ?? false;
    createRoles = json['create_roles'] ?? false;
    updateRoles = json['update_roles'] ?? false;
    deleteRoles = json['delete_roles'] ?? false;
    attachUserRole = json['attach_user_role'] ?? false;
    detachUserRole = json['detach_user_role'] ?? false;
    viewNotificationType = json['view_notification_type'] ?? false;
    updateNotificationTemplate = json['update_notification_template'] ?? false;
    viewSetting = json['view_setting'] ?? false;
    viewGeneralSetting = json['view_general_setting'] ?? false;
    updateSetting = json['update_setting'] ?? false;
    viewEmailSetting = json['view_email_setting'] ?? false;
    updateEmailSetting = json['update_email_setting'] ?? false;
    viewCronjob = json['view_cronjob'] ?? false;
    checkVerifyUpdate = json['check_verify_update'] ?? false;
    isAppAdmin = json['is_app_admin'] ?? false;
    isCustomer = json['is_customer'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['manage_global_access'] = manageGlobalAccess;
    data['manage_dashboard'] = manageDashboard;
    data['dashboard_statistics_view'] = dashboardStatisticsView;
    data['income_overview_dashboard'] = incomeOverviewDashboard;
    data['payment_overview_dashboard'] = paymentOverviewDashboard;
    data['expense_overview_dashboard'] = expenseOverviewDashboard;
    data['recent_invoice_dashboard'] = recentInvoiceDashboard;
    data['recent_estimate_dashboard'] = recentEstimateDashboard;
    data['recent_transaction_dashboard'] = recentTransactionDashboard;
    data['recent_expense_dashboard'] = recentExpenseDashboard;
    data['view_customers'] = viewCustomers;
    data['create_customers'] = createCustomers;
    data['update_customers'] = updateCustomers;
    data['delete_customers'] = deleteCustomers;
    data['details_view_customer'] = detailsViewCustomer;
    data['customer_resend_portal_access'] = customerResendPortalAccess;
    data['view_invoices'] = viewInvoices;
    data['create_invoices'] = createInvoices;
    data['update_invoices'] = updateInvoices;
    data['delete_invoices'] = deleteInvoices;
    data['due_payment_invoice'] = duePaymentInvoice;
    data['customer_due_invoice_payment'] = customerDueInvoicePayment;
    data['send_attachment_invoice'] = sendAttachmentInvoice;
    data['manage_invoice_clone'] = manageInvoiceClone;
    data['invoice_view_recurring'] = invoiceViewRecurring;
    data['download_invoice'] = downloadInvoice;
    data['download_thermal_invoice'] = downloadThermalInvoice;
    data['download_thermal_estimate'] = downloadThermalEstimate;
    data['view_estimates'] = viewEstimates;
    data['create_estimates'] = createEstimates;
    data['update_estimates'] = updateEstimates;
    data['delete_estimates'] = deleteEstimates;
    data['resend_mail_estimate'] = resendMailEstimate;
    data['download_estimate'] = downloadEstimate;
    data['status_change_estimate'] = statusChangeEstimate;
    data['invoice_convert_estimate'] = invoiceConvertEstimate;
    data['view_transactions'] = viewTransactions;
    data['view_categories'] = viewCategories;
    data['create_categories'] = createCategories;
    data['update_categories'] = updateCategories;
    data['delete_categories'] = deleteCategories;
    data['view_units'] = viewUnits;
    data['create_units'] = createUnits;
    data['update_units'] = updateUnits;
    data['delete_units'] = deleteUnits;
    data['view_products'] = viewProducts;
    data['create_products'] = createProducts;
    data['update_products'] = updateProducts;
    data['delete_products'] = deleteProducts;
    data['view_expenses'] = viewExpenses;
    data['create_expenses'] = createExpenses;
    data['update_expenses'] = updateExpenses;
    data['delete_expenses'] = deleteExpenses;
    data['payment_report_view'] = paymentReportView;
    data['transaction_report_view'] = transactionReportView;
    data['income_report_view'] = expenseReportView;
    data['expense_report_view'] = incomeReportView;
    data['view_taxes'] = viewTaxes;
    data['create_taxes'] = createTaxes;
    data['update_taxes'] = updateTaxes;
    data['delete_taxes'] = deleteTaxes;
    data['view_notes'] = viewNotes;
    data['create_notes'] = createNotes;
    data['update_notes'] = updateNotes;
    data['delete_notes'] = deleteNotes;
    data['view_payment_methods'] = viewPaymentMethods;
    data['create_payment_methods'] = createPaymentMethods;
    data['update_payment_methods'] = updatePaymentMethods;
    data['delete_payment_methods'] = deletePaymentMethods;
    data['customizations_view'] = customizationsView;
    data['invoice_setting_update'] = invoiceSettingUpdate;
    data['estimate_setting_update'] = estimateSettingUpdate;
    data['payment_setting_update'] = paymentSettingUpdate;
    data['view_users'] = viewUsers;
    data['update_users'] = updateUsers;
    data['delete_users'] = deleteUsers;
    data['manage_user_invite'] = manageUserInvite;
    data['view_roles'] = viewRoles;
    data['create_roles'] = createRoles;
    data['update_roles'] = updateRoles;
    data['delete_roles'] = deleteRoles;
    data['attach_user_role'] = attachUserRole;
    data['detach_user_role'] = detachUserRole;
    data['view_notification_type'] = viewNotificationType;
    data['update_notification_template'] = updateNotificationTemplate;
    data['view_setting'] = viewSetting;
    data['view_general_setting'] = viewGeneralSetting;
    data['update_setting'] = updateSetting;
    data['view_email_setting'] = viewEmailSetting;
    data['update_email_setting'] = updateEmailSetting;
    data['view_cronjob'] = viewCronjob;
    data['check_verify_update'] = checkVerifyUpdate;
    data['is_app_admin'] = isAppAdmin;
    data['is_customer'] = isCustomer;
    return data;
  }
}
