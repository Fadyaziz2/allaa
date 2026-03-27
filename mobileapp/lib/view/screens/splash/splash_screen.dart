import 'package:invoicex/controller/auth_controller.dart';
import 'package:invoicex/controller/onboarding_controller.dart';
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/theme/light_theme.dart';
import 'package:invoicex/util/app_constants.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/images.dart';
import 'package:invoicex/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/view/screens/notification/widget/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NotificationServices _notificationServices = NotificationServices();
  @override
  void initState() {
    _notificationServices.isRefreshToken();
    _notificationServices.getDeviceToken().then((token) {
      update(token);
    });
    _navigate();

    super.initState();
  }

  // navigate to dashboard or login screen
  void _navigate() async {
    final onboardingController = Get.find<OnboardingController>();
    final bool isOnboardingComplete =
        await onboardingController.isOnboardingComplete();

    Future.delayed(const Duration(seconds: 2), () {
      if (isOnboardingComplete) {
        if (Get.find<AuthController>().isLoggedIn() &&
            Get.find<AuthController>().isKeepMeLoggedIn()) {
          Get.offNamed(RouteHelper.getNavbarRoute());
        } else {
          Get.offNamed(RouteHelper.getLoginRoute());
        }
      } else {
        Get.offNamed(RouteHelper.getOnboardingRoute());
      }
    });
  }

  // //create device token
  update(String token) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('deviceToken', token);
    print('Device Token: $token');
  }

  @override
  Widget build(BuildContext context) {
    // check if user is logged in
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<PermissionController>().getPermissionInfo();
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // app logo
              Image.asset(
                Images.appLogo,
                height: 100,
              ),

              // app name
              Text(
                AppConstants.APP_NAME,
                style: poppinsBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                    color: LightAppColor.cardColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
