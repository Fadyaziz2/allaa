import 'package:invoicex/view/screens/administrator/roles/create_role.dart';
import 'package:invoicex/view/screens/customer/customer_filter_screen.dart';
import 'package:invoicex/view/screens/estimate/add_estimate_screen.dart';
import 'package:invoicex/view/screens/estimate/choose_template_screen.dart';
import 'package:invoicex/view/screens/estimate/estimate_filter_screen.dart';
import 'package:invoicex/view/screens/estimate/estimate_screen.dart';
import 'package:invoicex/view/screens/expenses/add_expenses_screen.dart';
import 'package:invoicex/view/screens/expenses/expense_filter_screen.dart';
import 'package:invoicex/view/screens/onboarding/onboarding_screen.dart';
import 'package:invoicex/view/screens/report/expense_report_screen.dart';
import 'package:invoicex/view/screens/invoice/create_invoice_screen.dart';
import 'package:invoicex/view/screens/invoice/invoice_filter_screen.dart';
import 'package:invoicex/view/screens/notification/notification_screen.dart';
import 'package:invoicex/view/screens/splash/splash_screen.dart';
import 'package:get/get.dart';
import '../view/screens/administrator/roles/role_filter_screen.dart';
import '../view/screens/administrator/roles/roles_screen.dart';
import '../view/screens/administrator/users/add_user_screen.dart';
import '../view/screens/administrator/users/user_filter_screen.dart';
import '../view/screens/administrator/users/user_screen.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/customer/add_customer_screen.dart';
import '../view/screens/customer/customer_details_screen.dart';
import '../view/screens/estimate/estimate_details_screen.dart';
import '../view/screens/expenses/expenses_category_screen.dart';
import '../view/screens/expenses/expenses_screen.dart';
import '../view/screens/forget/new_password_screen.dart';
import '../view/screens/forget/otp_verification_screen.dart';
import '../view/screens/invoice/invoice_details_screen.dart';
import '../view/screens/invoice/invoice_screen.dart';
import '../view/screens/navbar/navbar.dart';
import '../view/screens/forget/forget_password_screen.dart';
import '../view/screens/language/language_screen.dart';
import '../view/screens/payment/payment_method_screen.dart';
import '../view/screens/product/add_product_screen.dart';
import '../view/screens/product/product_filter_screen.dart';
import '../view/screens/product/product_screen.dart';
import '../view/screens/profile/profile_screen.dart';
import '../view/screens/report/expense_report_filter_screen.dart';
import '../view/screens/report/income_report_filter_screen.dart';
import '../view/screens/report/income_report_screen.dart';
import '../view/screens/setting/setting_screen.dart';
import '../view/screens/taxes/taxes_screen.dart';
import '../view/screens/trensaction/transaction_filter_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String navbar = '/navbar';
  static const String languageScreen = '/language';
  static const String loginScreen = '/login';
  static const String forgetPasswordScreen = '/forget-password';
  static const String checkEmailScreen = '/check-email';
  static const String customerDetailsScreen = '/customer-details';
  static const String invoiceDetailsScreen = '/invoice-details';
  static const String estimateDetailsScreen = '/estimate-details';
  static const String productScreen = '/product';
  static const String estimateScreen = '/estimate';
  static const String estimateFilterScreen = '/estimateFilter';
  static const String addEstimateScreen = '/addEstimate';
  static const String addUsersScreen = '/addUsers';
  static const String chooseTemplateScreen = '/chooseTemplate';
  static const String invoiceScreen = '/invoice';
  static const String userScreen = '/user-screen';
  static const String roleScreen = '/role-screen';
  static const String createInvoiceScreen = '/createInvoice';
  static const String createRoleScreen = '/createRoles';
  static const String invoiceFilterScreen = '/invoiceFilter';
  static const String userFilterScreen = '/userFilter';
  static const String roleFilterScreen = '/roleFilter';
  static const String addCustomerScreen = '/add-customer';
  static const String addProductScreen = '/add-product';
  static const String transactionFilterScreen = '/transaction-filter';
  static const String expansesScreen = '/expanses';
  static const String expansesCategoryScreen = '/expanses-category';
  static const String expansesFilterScreen = '/expansesFilter';
  static const String addExpansesScreen = '/addExpanses';
  static const String settingScreen = '/setting';
  static const String expansesReportScreen = '/expansesReport';
  static const String paymentMethodScreen = '/payment-method';
  static const String taxesScreen = '/taxes';
  static const String profileScreen = '/profile';
  static const String notificationScreen = '/notification';
  static const String otpVerificationScreen = '/otp-verification';
  static const String newPassword = '/new-password';
  static const String customerFilterScreen = '/customer-filter';
  static const String productFilterScreen = '/product-filter';
  static const String expensesReportFilterScreen = '/expenses-report-filter';
  static const String incomeReportFilterScreen = '/income-report-filter';
  static const String incomeReportScreen = '/income-report';

  // Get page name from route
  static String getInitialRoute() => '$initial';
  static String getOnboardingRoute() => onboarding;
  static String getNavbarRoute() => navbar;
  static String getLanguageRoute() => languageScreen;
  static String getLoginRoute() => loginScreen;
  static String getForgetPasswordRoute() => forgetPasswordScreen;
  static String getCheckEmailScreenRoute() => checkEmailScreen;
  static String getCustomerDetailsRoute() => customerDetailsScreen;
  static String getInvoiceDetailsRoute() => invoiceDetailsScreen;
  static String getEstimateDetailsRoute() => estimateDetailsScreen;
  static String getProductRoute() => productScreen;
  static String getEstimateRoute() => estimateScreen;
  static String getEstimateFilterRoute() => estimateFilterScreen;
  static String getChooseTemplateRoute(String value) =>
      "$chooseTemplateScreen?value=$value";
  static String getInvoiceRoute() => invoiceScreen;
  static String getUserRoute() => userScreen;
  static String getRoleRoute() => roleScreen;
  static String getCreateInvoiceRoute(String value) => "$createInvoiceScreen?value=$value";
  static String getCreateRoleRoute(String update) => "$createRoleScreen?update=$update";
  static String getInvoiceFilterRoute() => invoiceFilterScreen;
  static String getUserFilterRoute() => userFilterScreen;
  static String getRolesFilterRoute() => roleFilterScreen;

  static String getAddUsersRoute() => "$addUsersScreen";

  static String getAddEstimateRoute(String value) => "$addEstimateScreen?value=$value";
  static String getAddCustomerRoute(String update) =>
      "$addCustomerScreen?update=$update";
  static String getAddProductRoute(String update) =>
      "$addProductScreen?update=$update";
  static String getTransactionFilterRoute() => transactionFilterScreen;
  static String getExpansesRoute() => expansesScreen;
  static String getExpansesCategoryRoute() => expansesCategoryScreen;
  static String getExpansesFilterRoute() => expansesFilterScreen;
  static String getAddExpensesRoute(String update) =>
      "$addExpansesScreen?update=$update";
  static String getSettingRoute() => settingScreen;
  static String getExpensesReportRoute() => expansesReportScreen;
  static String getPaymentMethodRoute() => paymentMethodScreen;
  static String getTaxesRoute() => taxesScreen;
  static String getProfileRoute() => profileScreen;
  static String getNotificationRoute() => notificationScreen;
  static String getOtpVerificationRoute(String email) => "$otpVerificationScreen?email=$email";
  static String getNewPasswordRoute(String email, String token) => "$newPassword?email=$email&token=$token";
  static String getCustomerFilterRoute() => customerFilterScreen;
  static String getProductFilterRoute() => productFilterScreen;
  static String getExpensesReportFilterRoute() => expensesReportFilterScreen;
  static String getIncomeReportFilterRoute() => incomeReportFilterScreen;
  static String getIncomeReportRoute() => incomeReportScreen;

// call this method from main screen to push all routes
  static List<GetPage> routes = [
    GetPage(name: initial, page: () => SplashScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: navbar, page: () => const Navbar()),
    GetPage(name: languageScreen, page: () => const LanguageScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: forgetPasswordScreen, page: () => ForgetPasswordScreen()),
    GetPage(
        name: customerDetailsScreen, page: () => const CustomerDetailsScreen()),
    GetPage(name: invoiceDetailsScreen, page: () => InvoiceDetailsScreen()),
    GetPage(name: estimateDetailsScreen, page: () => EstimateDetailsScreen()),
    GetPage(name: productScreen, page: () => const ProductScreen()),
    GetPage(name: estimateScreen, page: () => const EstimateScreen()),
    GetPage(name: estimateFilterScreen, page: () => const EstimateFilterScreen()),

    GetPage(name: addUsersScreen, page: () => AddUsersScreen()),

    GetPage(name: addEstimateScreen, page: () => AddEstimateScreen(value: Get.parameters['value'] ?? '1',)),
    GetPage(
        name: chooseTemplateScreen,
        page: () => ChooseTemplateScreen(
            isEstimate: Get.parameters['value'] == 'estimate' ? true : false)),
    GetPage(name: invoiceScreen, page: () => InvoiceScreen()),

    GetPage(name: userScreen, page: () => UserScreen()),
    GetPage(name: roleScreen, page: () => RolesScreen()),

    GetPage(
        name: createRoleScreen,
        page: () => CreateRoles(
              isUpdate: Get.parameters['update']!,
            )),
    GetPage(
        name: createInvoiceScreen,
        page: () => CreateInvoiceScreen(
              value: Get.parameters['value'] ?? '1',
            )),
    GetPage(
        name: createInvoiceScreen,
        page: () => CreateInvoiceScreen(
              value: Get.parameters['value']!,
            )),
    GetPage(name: invoiceFilterScreen, page: () => const InvoiceFilterScreen()),

    GetPage(name: userFilterScreen, page: () => const UserFilterScreen()),
    GetPage(name: roleFilterScreen, page: () => const RoleFilterScreen()),

    GetPage(
        name: addCustomerScreen,
        page: () => AddCustomerScreen(isUpdate: Get.parameters['update']!)),
    GetPage(
        name: addProductScreen,
        page: () => AddProductScreen(isUpdate: Get.parameters['update']!)),
    GetPage(
        name: transactionFilterScreen,
        page: () => const TransactionFilterScreen()),
    GetPage(name: expansesScreen, page: () => const ExpensesScreen()),
    GetPage(
        name: expansesCategoryScreen,
        page: () => const ExpensesCategoryScreen()),
    GetPage(
        name: expansesFilterScreen, page: () => const ExpensesFilterScreen()),
    GetPage(
        name: addExpansesScreen,
        page: () => AddExpensesScreen(isUpdate: Get.parameters['update']!)),
    GetPage(name: settingScreen, page: () => const SettingScreen()),
    GetPage(
        name: expansesReportScreen, page: () => const ExpensesReportScreen()),
    GetPage(name: paymentMethodScreen, page: () => const PaymentMethodScreen()),
    GetPage(name: taxesScreen, page: () => const TaxesScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: notificationScreen, page: () => const NotificationScreen()),
    GetPage(name: otpVerificationScreen, page: () => OtpVerificationScreen(email: Get.parameters['email']!)),
    GetPage(name: newPassword, page: () => NewPasswordScreen(resetToken: Get.parameters['token']!, email: Get.parameters['email']!)),
    GetPage(
        name: customerFilterScreen, page: () => const CustomerFilterScreen()),
    GetPage(name: productFilterScreen, page: () => const ProductFilterScreen()),
    GetPage(
        name: expensesReportFilterScreen,
        page: () => const ExpensesReportFilterScreen()),
    GetPage(
        name: incomeReportFilterScreen,
        page: () => const IncomeReportFilterScreen()),
    GetPage(name: incomeReportScreen, page: () => const IncomeReportScreen())
  ];
}
