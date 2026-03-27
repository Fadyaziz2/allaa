// ignore_for_file: deprecated_member_use

import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/base/switch_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/dashboard_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _emailController.text = Get.find<AuthController>().getUserEmail();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,

        // body start
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                //  Login form start
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Login heading
                      Text(
                        "login_key".tr,
                        style: poppinsBold.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.FONT_SIZE_OVER_X_LARGE),
                      ),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_SMALL,
                      ),

                      // Login description
                      Text(
                        "enter_your_credentials_to_continue_key".tr,
                        textAlign: TextAlign.center,
                        style: poppinsRegular.copyWith(
                            color: Get.isDarkMode
                                ? Colors.white
                                : Theme.of(context).disabledColor,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      ),
                      const SizedBox(
                        height: 100,
                      ),

                      // Email TextField
                      CustomTextField(
                        header: "email_key".tr,
                        isRequired: true,
                        hintText: 'enter_your_email_key'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Images.emailIcon,
                      ),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_DEFAULT,
                      ),

                      // Password TextField
                      CustomTextField(
                        header: "password_key".tr,
                        isRequired: true,
                        hintText: 'enter_your_password_key'.tr,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Images.lockIcon,
                        isPassword: true,
                        onSubmit: () {},
                      ),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_DEFAULT,
                      ),

                      // Keep me logged in Switch button
                      SwitchButton(
                          isButtonActive: authController.isActiveRememberMe,
                          title: "keep_me_logged_in_key".tr,
                          onTap: () {
                            authController.toggleRememberMe();
                          }),
                      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                      // Login button
                      CustomButton(
                        buttonTextWidget: authController.isLoading
                            ? const Center(
                          child: SizedBox(
                              height: 23,
                              width: 23,
                              child: LoadingIndicator(
                                isWhiteColor: true,
                              )),
                        )
                            : null,
                        buttonText: "login_key".tr,
                        textColor: Theme.of(context).indicatorColor,
                        onPressed: authController.isLoading
                            ? () {}
                            : () {
                          if (_emailController.text.trim().isEmpty) {
                            showCustomSnackBar(
                                'please_enter_valid_email_key'.tr,
                                isError: true);
                          } else if (_passwordController.text
                              .trim()
                              .isEmpty) {
                            showCustomSnackBar(
                                'please_enter_password_key'.tr,
                                isError: true);
                          } else {
                            _login(authController);
                          }
                        },
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                      //  Forget your password  text button
                      TextButton(
                        onPressed: () {
                          Get.toNamed(RouteHelper.getForgetPasswordRoute());
                        },
                        child: Text(
                          "forgot_your_password_key".tr,
                          style: poppinsMedium.copyWith(
                              color: Theme.of(context).primaryColor),
                        ),
                      ),

                    ],
                  );
                }),
              ),
            ),
          ),
        ));
  }

  // login method start
  void _login(AuthController authController) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    SharedPreferences storage = await SharedPreferences.getInstance();
    var deviceToken = storage.getString('deviceToken');
    print("deviceToken : $deviceToken");
    authController.login(email: email, password: password,deviceToken: deviceToken).then((status) async {
      if (status.isSuccess) {
        if (authController.isActiveRememberMe) {
          authController.saveUserNumberAndPassword(email: email, password: password);
          authController.saveKeepMeLoggedIn();
        } else {
          authController.clearUserNumberAndPassword();
          authController.saveKeepMeLoggedIn();
        }
        Get.find<DashboardController>().getProfileDetails();
        Get.offNamed(RouteHelper.getNavbarRoute());
      } else {
        showCustomSnackBar(status.message);
      }
    });
  }

}
