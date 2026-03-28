// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:invoicex/controller/dashboard_controller.dart';
import 'package:invoicex/controller/invoice_controller.dart';
import 'package:invoicex/controller/notification_controller.dart';
import 'package:invoicex/controller/onboarding_controller.dart';
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/controller/theme_controller.dart';
import 'package:invoicex/data/repository/invoice_repo.dart';
import 'package:invoicex/data/repository/expenses_repo.dart';
import 'package:invoicex/data/repository/notification_repo.dart';
import 'package:invoicex/data/repository/payment_methods_repo.dart';
import 'package:invoicex/data/repository/permission_repo.dart';
import 'package:invoicex/data/repository/report_repo.dart';
import 'package:invoicex/data/repository/tax_repo.dart';
import 'package:invoicex/data/repository/transaction_repo.dart';
import 'package:flutter/services.dart';
 import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../controller/administrator_role_controller.dart';
import '../controller/administrator_user_controller.dart';
import '../controller/auth_controller.dart';
import '../controller/customer_controller.dart';
import '../controller/estimate_controller.dart';
import '../controller/expenses_controller.dart';
import '../controller/localization_controller.dart';
import '../controller/payment_controller.dart';
import '../controller/purchase_controller.dart';
import '../controller/product_controller.dart';
import '../controller/report_controller.dart';
import '../controller/taxes_controller.dart';
import '../controller/transaction_controller.dart';
import '../controller/wastage_controller.dart';
import '../data/api/api_client.dart';
import '../data/model/response/language_model.dart';
import '../data/repository/administrator_role_repo.dart';
import '../data/repository/administrator_user_repo.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/customer_repo.dart';
import '../data/repository/dashboard_repo.dart';
import '../data/repository/estimate_repo.dart';
import '../data/repository/product_repo.dart';
import '../data/repository/wastage_repo.dart';
import '../data/repository/purchase_repo.dart';
import '../util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();


  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Theme Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => PermissionRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => TransactionRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => DashboardRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CustomerRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ExpensesRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ProductRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => WastageRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => PurchaseRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  Get.lazyPut(() => TaxRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  Get.lazyPut(() => PaymentMethodsRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => EstimateRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => InvoiceRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  Get.lazyPut(() => AdministratorUserRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  Get.lazyPut(() => AdministratorRoleRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  Get.lazyPut(() => ReportRepo(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => OnboardingController());
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => PermissionController(
      sharedPreferences: Get.find(), permissionRepo: Get.find()));
  Get.lazyPut(
      () => LocalizationController(
          sharedPreferences: Get.find(), apiClient: Get.find()),
      fenix: true);
  Get.lazyPut(() => DashboardController(dashboardRepo: Get.find()));


  Get.lazyPut(() => ProductController(productRepo: Get.find()));
  Get.lazyPut(() => WastageController(wastageRepo: Get.find()));
  Get.lazyPut(() => EstimateController(estimateRepo: Get.find()));
  Get.lazyPut(() => CustomerController(customerRepo: Get.find()));
  Get.lazyPut(() => InvoiceController(invoiceRepo: Get.find()));
  Get.lazyPut(() => TransactionController(transactionRepo: Get.find()));
  Get.lazyPut(() => ExpensesController(expensesRepo: Get.find()));
  Get.lazyPut(() => PaymentController(paymentMethodsRepo: Get.find()));
  Get.lazyPut(() => PurchaseController(purchaseRepo: Get.find()));
  Get.lazyPut(() => TaxesController(taxRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));

  Get.lazyPut(() => ReportController(reportRepo: Get.find()));

  Get.lazyPut(() => AdministratorUserController(administratorUserRepo: Get.find()));

  Get.lazyPut(() => AdministratorRolesController(administratorRoleRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = {};
    mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        _json;
  }

  return languages;
}
