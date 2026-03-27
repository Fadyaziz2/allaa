// ignore_for_file: deprecated_member_use
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/controller/auth_controller.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/custom_button.dart';
import 'package:invoicex/view/base/custom_snackbar.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import '../../../helper/route_helper.dart';
import '../../base/custom_text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final FocusNode _emailFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
        isBackButtonExist: true,

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_LARGE),
        child: GetBuilder<AuthController>(builder: (authController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Dimensions.PADDING_SIZE_DEFAULT,
              ),

              // Show forget password form
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    //  Forgot password form start
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Forget password heading
                        Text(
                          "forgot_password_key".tr,
                          style: poppinsMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_OVER_X_LARGE),
                        ),
                        const SizedBox(
                          height: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        // Forget password description
                        Text(
                          "please_enter_your_email_address_below_to_receive_key"
                              .tr,
                          textAlign: TextAlign.center,
                          style: poppinsRegular.copyWith(
                              color: Get.isDarkMode
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).disabledColor,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        // User email input field
                        CustomTextField(
                          header: "email_key".tr,
                          isRequired: true,
                          hintText: 'enter_your_email_key'.tr,
                          controller: _emailController,
                          focusNode: _emailFocus,
                          inputType: TextInputType.emailAddress,
                          inputAction: TextInputAction.done,
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        // Send reset password button
                        CustomButton(
                          buttonTextWidget: authController.isGenerateOtpLoading
                              ? const Center(
                                  child: SizedBox(
                                      height: 23,
                                      width: 23,
                                      child: LoadingIndicator(
                                        isWhiteColor: true,
                                      )),
                                )
                              : null,
                          onPressed: authController.isGenerateOtpLoading
                              ? () {}
                              : () {
                                  if (_emailController.text.trim().isEmpty) {
                                    showCustomSnackBar(
                                        'please_enter_valid_email_key'.tr,
                                        isError: true);
                                  } else {
                                    authController
                                        .generateOtp(
                                            email: _emailController.text.trim())
                                        .then((value) {
                                      if (value.isSuccess) {
                                        Get.toNamed(RouteHelper.getOtpVerificationRoute(_emailController.text.trim()));
                                      } else {
                                        showCustomSnackBar(value.message,
                                            isError: true);
                                      }
                                    });
                                  }
                                },
                          buttonText: "send_reset_password_key".tr,
                          textColor: Theme.of(context).indicatorColor,
                        ),
                        const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE,
                        ),

                        // Remember your password
                        RichText(
                          text: TextSpan(
                            text: 'remember_your_password_key'.tr,
                            style: poppinsRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: Get.isDarkMode
                                    ? Theme.of(context).indicatorColor
                                    : Theme.of(context).disabledColor),
                            children: [
                              TextSpan(
                                text: 'login_key'.tr,
                                style: poppinsMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(RouteHelper.getLoginRoute());
                                  },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
