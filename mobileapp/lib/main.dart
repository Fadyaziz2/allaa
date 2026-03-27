import 'package:firebase_core/firebase_core.dart';
import 'package:invoicex/theme/dark_theme.dart';
import 'package:invoicex/theme/light_theme.dart';
import 'package:invoicex/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/localization_controller.dart';
import 'controller/theme_controller.dart';
import 'helper/get_di.dart' as di;
import 'helper/route_helper.dart';
import 'util/messages.dart';

// Main file to run the app
Future<void> main() async {
  // widgets binding ensureInitialized
  WidgetsFlutterBinding.ensureInitialized();

  const firebaseOptions = FirebaseOptions(
    apiKey: AppConstants.apiKey,
    appId: AppConstants.appId,
    messagingSenderId: AppConstants.messagingSenderId,
    projectId: AppConstants.projectId,
    authDomain: AppConstants.authDomain,
    storageBucket: AppConstants.storageBucket,
    measurementId: AppConstants.measurementId,
    iosBundleId: AppConstants.iosBundleId,
    databaseURL: AppConstants.databaseURL,
  );
  // Initialize Firebase based on the platform
  if (GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
  } else {
    await Firebase.initializeApp();
  }

  await di.init();
  Map<String, Map<String, String>> languages = await di.init();
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: AppConstants.APP_NAME,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              theme: themeController.darkTheme ? dark : light,
              locale: localizeController.locale,
              initialRoute: RouteHelper.getInitialRoute(),
              getPages: RouteHelper.routes,
              defaultTransition: Transition.topLevel,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
                  AppConstants.languages[0].countryCode),
              transitionDuration: const Duration(milliseconds: 500),
            );
          },
        );
      },
    );
  }
}
