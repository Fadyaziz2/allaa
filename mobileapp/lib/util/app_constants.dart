// ignore_for_file: constant_identifier_names

import '../data/model/response/language_model.dart';
import 'images.dart';

class AppConstants {
  // Flutter SDk Version 3.32.0
  static const String APP_NAME = 'ِallaGallo';
  static const double APP_VERSION = 3.0;

  // Shared Keyc
  static const String THEME = 'theme';

  // BASE URL LINK
  static const String BASE_URL = 'https://islandeg.com/api/mobile';
  static const String DOMAIN_URL = 'https://islandeg.com';

  // static const String BASE_URL = 'https://islandeg.com/api/mobile';
  // static const String DOMAIN_URL = 'https://islandeg.com';

  // API END POINT

  // Auth
  static const String LOGIN_URI = '/auth/login';
  static const String GENERATE_OTP_URI = '/auth/generate-otp';
  static const String OTP_VERIFICATION_URI = '/auth/verify-otp';
  static const String CHANGE_PASSWORD_URI = '/auth/confirm-password';
  static const String GET_PERMISSION_URI = '/selected/settings';

  // Dashboard
  static const String GET_DASHBOARD_INFO_URI = '/dashboard/statistics';
  static const String GET_PAYMENT_OVERVIEW_URI = '/dashboard/payment-overview';
  static const String GET_INCOME_OVERVIEW_URI = '/dashboard/income-overview/';

  // Transaction
  static const String GET_TRANSACTION_URI = '/transactions';

  // Notes
  static const String GET_NOTES_URI = '/notes';
  static const String ADD_NOTES_URI = '/notes';
  static const String EDIT_NOTES_URI = '/notes/';
  static const String DELETE_NOTES_URI = '/notes/';

  // Tax
  static const String GET_TAX_URI = '/taxes';
  static const String ADD_TAX_URI = '/taxes';
  static const String EDIT_TAX_URI = '/taxes/';
  static const String DELETE_TAX_URI = '/taxes/';

  // Payment
  static const String GET_PAYMENT_METHODS_URI = '/payment-methods';
  static const String ADD_PAYMENT_METHODS_URI = '/payment-methods';
  static const String EDIT_PAYMENT_METHODS_URI = '/payment-methods/';
  static const String DELETE_PAYMENT_METHODS_URI = '/payment-methods/';
  static const String GET_PAYMENT_METHODS_DETAILS_URI = '/payment-methods/';
  static const String UPDATE_PAYMENT_METHODS_URI = '/payment-methods/';

  // Customer
  static const String GET_CUSTOMER_URI = '/customers';
  static const String ADD_CUSTOMER_URI = '/customers';
  static const String GET_CUSTOMER_DETAILS_URI = '/customers-details/';
  static const String GET_CUSTOMER_INVOICE_DETAILS_URI =
      '/customers-invoice-details/';
  static const String DELETE_CUSTOMER_URI = '/customers/';
  static const String CUSTOMER_RESEND_PORTAL_ACCESS_URI =
      '/customer-resend-portal-access/';
  static const String CUSTOMER_UPDATE_STATUS_URI = '/customer-update-status/';
  static const String GET_CUSTOMER_UPDATE_DETAILS_URI = '/customers/';
  static const String CUSTOMER_UPDATE_URI = '/customers/';

  // Expenses
  static const String GET_EXPENSES_URI = '/expenses';
  static const String ADD_EXPENSES_URI = '/expenses';
  static const String DELETE_EXPENSES_URI = '/expenses/';
  static const String GET_EXPENSES_CATEGORY_URI = '/categories';
  static const String ADD_EXPENSES_CATEGORY_URI = '/categories';
  static const String EDIT_EXPENSES_CATEGORY_URI = '/categories/';
  static const String DELETE_EXPENSES_CATEGORY_URI = '/categories/';
  static const String GET_EXPENSES_DETAILS_URI = '/expenses/';
  static const String UPDATE_EXPENSES_URI = '/expenses/';

  // Select
  static const String GET_CATEGORIES_URI = '/selected/categories';
  static const String GET_UNITS_URI = '/selected/units';
  static const String GET_PAYMENT_METHODS_DROPDOWN_URI =
      '/selected/payment-methods';
  static const String GET_NOTE_TYPE_URI = '/selected/note-types';
  static const String GET_PAYMENT_METHODS_DROPDOWN_LIST_URI =
      '/selected/payment-method-lists';
  static const String GET_PAYMENT_GATEWAY_DROPDOWN_LIST_URI =
      '/selected/customer-payment-method';

  // Estimate
  static const String GET_ESTIMATE_URI = '/estimates';
  static const String CREATE_ESTIMATE_URI = '/estimates';
  static const String GET_ESTIMATE_DETAILS_URI = '/estimates/';
  static const String UPDATE_ESTIMATE_URI = '/estimates/';
  static const String ESTIMATE_SEND_ATTACHMENT_URI =
      '/estimate-send-attachment/';
  static const String ESTIMATE_STATUS_UPDATE_URI = '/estimate-update-status/';
  static const String ESTIMATE_INVOICE_CONVERT_URI =
      '/estimate-invoice-convert/';
  static const String DELETE_ESTIMATE_URI = '/estimates/';
  static const String DOWNLOAD_ESTIMATE_URI = '/estimate-download/';
  static const String VIEW_ESTIMATE_URI = '/estimate-download/';
  static const String THERMAL_ESTIMATE_DOWNLOAD_URI =
      '/thermal-estimate-download/';

  // Invoice
  static const String GET_INVOICE_URI = '/invoices';
  static const String GET_SUGGEST_CUSTOMER_URI = '/selected/customers';
  static const String GET_SUGGEST_DISCOUNT_TYPE_URI =
      '/selected/discount-types';
  static const String GET_SUGGEST_PRODUCT_URI = '/selected/products';
  static const String GET_SUGGEST_TAXES_URI = '/selected/taxes';
  static const String GET_SUGGEST_NOTES_URI = '/selected/notes';
  static const String CREATE_INVOICE_URI = '/invoices';
  static const String GET_INVOICE_DETAILS_URI = '/invoices/';
  static const String UPDATE_INVOICE_URI = '/invoices/';
  static const String RESEND_INVOICE_URI = '/invoice-send-attachment/';
  static const String CLONE_INVOICE_URI = '/invoice-clone/';
  static const String DELETE_INVOICE_URI = '/invoices/';
  static const String DOWNLOAD_INVOICE_URI = '/invoice-download/';
  static const String VIEW_INVOICE_URI = '/invoice-download/';
  static const String DUE_PAYMENT_URI = '/invoice-due-payment/';
  static const String CUSTOMER_INVOICE_DUE_PAYMENT_URI =
      '/invoice-customer-due-payment/';
  static const String THERMAL_INVOICE_DOWNLOAD_URI =
      '/thermal-invoice-download/';

  // Product
  static const String GET_PRODUCTS_URI = '/products';
  static const String ADD_PRODUCT_URI = '/products';
  static const String DELETE_PRODUCT_URI = '/products/';
  static const String GET_PRODUCT_DETAILS_URI = '/products/';
  static const String UPDATE_PRODUCT_URI = '/products/';

  static const String GET_PRODUCT_CATEGORIES_URI = '/product-categories';
  static const String ADD_PRODUCT_CATEGORIES_URI = '/product-categories';
  static const String GET_UNITS_LIST_URI = '/units';
  static const String ADD_UNITS_URI = '/units';

  // Profile
  static const String GET_PROFILE_URI = '/my-profile';
  static const String UPDATE_PROFILE_URI = '/my-profile';

  // Notification
  static const String GET_NOTIFICATION_READ_STATUS = '/get-unread-notification';
  static const String GET_NOTIFICATION = '/notifications';
  static const String READ_ALL_NOTIFICATION = '/read-all-notifications';

  // Report
  static const String GET_INCOME_REPORT_URI = '/income-report';
  static const String GET_EXPENSES_REPORT_URI = '/expense-report';

  //administrator
  static const String GET_USER_URI = '/users';
  static const String ROLE_URI = '/selected/roles';
  static const String USER_INVITE_CREATE_URI = '/user-invite';
  static const String GET_ROLE_URI = '/roles';
  static const String GET_ROLE_PERMISSION_URI = '/permissions';

  // Shared Key
  static const String USER_PASSWORD = 'user_password';
  static const String USER_EMAIL = 'user_email';
  static const String USER_ADDRESS = 'user_address';
  static const String LOCALIZATION_KEY = 'X-localization';
  static const String TOKEN = 'access_token';
  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';
  static const String KEEP_ME_LOGGED_IN = 'keep_me_logged_in';
  static const String PERMISSION = 'permission_status';
  static const String APP_LOGO = 'app_logo';

  // Notification FirebaseOptions Key
  static const String apiKey = 'AIzaSyAKGWHuIIBrpkhhYbUHQjag28YpbB4TbuA';
  static const String appId = '1:213354955498:android:cfda647e1f8d3f726f0d93';
  static const String messagingSenderId = '213354955498';
  static const String projectId = 'zabi-test-8d2aa';
  static const String authDomain = 'zabi-test-8d2aa.firebaseapp.com';
  static const String storageBucket = 'zabi-test-8d2aa.appspot.com';
  static const String measurementId = 'G-07VGJJVGTT';
  static const String iosBundleId = 'com.theme29.invoicex';
  static const String databaseURL =
      'https://demotest-a6d92-default-rtdb.firebaseio.com';

  // All Language model list section
  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.englishIcon,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.afghanistanIcon,
        languageName: 'Afghanistan',
        countryCode: 'AF',
        languageCode: 'fa'),
    LanguageModel(
        imageUrl: Images.algeriaIcon,
        languageName: 'Algeria',
        countryCode: 'DZ',
        languageCode: 'ar'),
    LanguageModel(
        imageUrl: Images.argentinaIcon,
        languageName: 'Argentina',
        countryCode: 'AR',
        languageCode: 'es'),
    LanguageModel(
        imageUrl: Images.arabicIcon,
        languageName: 'Arabic',
        countryCode: 'SA',
        languageCode: 'ar'),
    LanguageModel(
        imageUrl: Images.bangladeshIcon,
        languageName: 'Bangladesh',
        countryCode: 'BD',
        languageCode: 'bn'),
    LanguageModel(
        imageUrl: Images.brazilIcon,
        languageName: 'Brazil',
        countryCode: 'BR',
        languageCode: 'pt'),
    LanguageModel(
        imageUrl: Images.chinaIcon,
        languageName: 'Chinese',
        countryCode: 'CN',
        languageCode: 'zh'),
    LanguageModel(
        imageUrl: Images.croatiaIcon,
        languageName: 'Croatia',
        countryCode: 'HR',
        languageCode: 'hr'),
    LanguageModel(
        imageUrl: Images.cyprusIcon,
        languageName: 'Cyprus',
        countryCode: 'CY',
        languageCode: 'el'),
    LanguageModel(
        imageUrl: Images.denmarkIcon,
        languageName: 'Denmark',
        countryCode: 'DK',
        languageCode: 'da'),
    LanguageModel(
        imageUrl: Images.finlandIcon,
        languageName: 'Finland',
        countryCode: 'FI',
        languageCode: 'fi'),
    LanguageModel(
        imageUrl: Images.franceIcon,
        languageName: 'France',
        countryCode: 'FR',
        languageCode: 'fr'),
    LanguageModel(
        imageUrl: Images.germanyIcon,
        languageName: 'Germany',
        countryCode: 'DE',
        languageCode: 'de'),
    LanguageModel(
        imageUrl: Images.greeceIcon,
        languageName: 'Greece',
        countryCode: 'GR',
        languageCode: 'el'),
    LanguageModel(
        imageUrl: Images.indiaIcon,
        languageName: 'India',
        countryCode: 'IN',
        languageCode: 'hi'),
    LanguageModel(
        imageUrl: Images.indonesiaIcon,
        languageName: 'Indonesia',
        countryCode: 'ID',
        languageCode: 'id'),
    LanguageModel(
        imageUrl: Images.iranIcon,
        languageName: 'Iran',
        countryCode: 'IR',
        languageCode: 'fa'),
    LanguageModel(
        imageUrl: Images.irelandIcon,
        languageName: 'Ireland',
        countryCode: 'IE',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.italyIcon,
        languageName: 'Italy',
        countryCode: 'IT',
        languageCode: 'it'),
    LanguageModel(
        imageUrl: Images.japanIcon,
        languageName: 'Japan',
        countryCode: 'JP',
        languageCode: 'ja'),
    LanguageModel(
        imageUrl: Images.kenyaIcon,
        languageName: 'Kenya',
        countryCode: 'KE',
        languageCode: 'sw'),
    LanguageModel(
        imageUrl: Images.malaysiaIcon,
        languageName: 'Malaysia',
        countryCode: 'MY',
        languageCode: 'ms'),
    LanguageModel(
        imageUrl: Images.mexicoIcon,
        languageName: 'Mexico',
        countryCode: 'MX',
        languageCode: 'es'),
    LanguageModel(
        imageUrl: Images.moroccoIcon,
        languageName: 'Morocco',
        countryCode: 'MA',
        languageCode: 'ar'),
    LanguageModel(
        imageUrl: Images.netherlandsIcon,
        languageName: 'Netherlands',
        countryCode: 'NL',
        languageCode: 'nl'),
    LanguageModel(
        imageUrl: Images.nigeriaIcon,
        languageName: 'Nigeria',
        countryCode: 'NG',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.norwayIcon,
        languageName: 'Norway',
        countryCode: 'NO',
        languageCode: 'no'),
    LanguageModel(
        imageUrl: Images.pakistanIcon,
        languageName: 'Pakistan',
        countryCode: 'PK',
        languageCode: 'ur'),
    LanguageModel(
        imageUrl: Images.palestineIcon,
        languageName: 'Palestine',
        countryCode: 'PS',
        languageCode: 'ar'),
    LanguageModel(
        imageUrl: Images.philippinesIcon,
        languageName: 'Philippines',
        countryCode: 'PH',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.polandIcon,
        languageName: 'Poland',
        countryCode: 'PL',
        languageCode: 'pl'),
    LanguageModel(
        imageUrl: Images.portugalIcon,
        languageName: 'Portugal',
        countryCode: 'PT',
        languageCode: 'pt'),
    LanguageModel(
        imageUrl: Images.romaniaIcon,
        languageName: 'Romania',
        countryCode: 'RO',
        languageCode: 'ro'),
    LanguageModel(
        imageUrl: Images.russiaIcon,
        languageName: 'Russia',
        countryCode: 'RU',
        languageCode: 'ru'),
    LanguageModel(
        imageUrl: Images.singaporeIcon,
        languageName: 'Singapore',
        countryCode: 'SG',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.southAfricaIcon,
        languageName: 'South Africa',
        countryCode: 'ZA',
        languageCode: 'af'),
    LanguageModel(
        imageUrl: Images.spainIcon,
        languageName: 'Spain',
        countryCode: 'ES',
        languageCode: 'es'),
    LanguageModel(
        imageUrl: Images.sriLankaIcon,
        languageName: 'Sri Lanka',
        countryCode: 'LK',
        languageCode: 'si'),
    LanguageModel(
        imageUrl: Images.swedenIcon,
        languageName: 'Sweden',
        countryCode: 'SE',
        languageCode: 'sv'),
    LanguageModel(
        imageUrl: Images.switzerlandIcon,
        languageName: 'Switzerland',
        countryCode: 'CH',
        languageCode: 'de'),
    LanguageModel(
        imageUrl: Images.thailandIcon,
        languageName: 'Thailand',
        countryCode: 'TH',
        languageCode: 'th'),
    LanguageModel(
        imageUrl: Images.turukishIcon,
        languageName: 'Turkish',
        countryCode: 'TR',
        languageCode: 'tr'),
    LanguageModel(
        imageUrl: Images.uzbekistanIcon,
        languageName: 'Uzbekistan',
        countryCode: 'UZ',
        languageCode: 'uz')
  ];
}
