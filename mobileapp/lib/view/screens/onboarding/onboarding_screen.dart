// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/onboarding_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/theme/light_theme.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/images.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/custom_button.dart';
import 'package:invoicex/view/screens/onboarding/widgets/body_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  // page view list
  final List<Widget> _pages = [
    BodyWidget(
      title: 'Welcome to InvoiceX',
      description: 'Your Ultimate Billing Companion',
      image: Images.onboarding1,
    ),
    BodyWidget(
      title: 'Invoice Management',
      description: 'Track and manage all your invoices instantly.',
      image: Images.onboarding2,
    ),
    BodyWidget(
      title: 'Quotations',
      description: 'Create and send professional quotations.',
      image: Images.onboarding3,
    ),
    BodyWidget(
      title: 'Customer Management',
      description: 'Keep all your customer information organized.',
      image: Images.onboarding4,
    ),
    BodyWidget(
      title: 'Product List',
      description: 'Manage your product details efficiently.',
      image: Images.onboarding5,
    ),
    BodyWidget(
      title: 'Settings',
      description: 'Customize the app to suit your needs.',
      image: Images.onboarding6,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<OnboardingController>(
        builder: (onboardingController) {
          return Column(
            children: [
              // Page view
              Expanded(
                flex: 2,
                child: PageView.builder(
                  controller: onboardingController.pageController,
                  onPageChanged: (index) =>
                      onboardingController.setCurrentIndex(index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _pages[index];
                  },
                ),
              ),

              // Indicator section and buttons section
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicator
                  _buildIndicator(context, onboardingController),

                  // Buttons
                  _buildButtons(context, onboardingController),
                  SizedBox(),
                ],
              )),
            ],
          );
        },
      ),
    );
  }

// Indicator
  Widget _buildIndicator(
      BuildContext context, OnboardingController onboardingController) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_pages.length, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL - 1),
            height: Dimensions.PADDING_SIZE_SMALL - 2,
            width: onboardingController.currentIndex.value == index
                ? Dimensions.PADDING_SIZE_EXTRA_LARGE
                : Dimensions.PADDING_SIZE_SMALL - 2,
            decoration: BoxDecoration(
              color: onboardingController.currentIndex.value == index
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(
                Dimensions.PADDING_SIZE_SMALL + 2,
              ),
            ),
          );
        }),
      );
    });
  }

// Buttons
  Widget _buildButtons(
      BuildContext context, OnboardingController onboardingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(
        children: [
          // Next Button and Done Button
          Obx(
            () => CustomButton(
              radius: Dimensions.RADIUS_DEFAULT,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              textColor: LightAppColor.cardColor,
              buttonText:
                  onboardingController.currentIndex.value == _pages.length - 1
                      ? "Done"
                      : "Next",
              onPressed: () async {
                if (onboardingController.currentIndex.value ==
                    _pages.length - 1) {
                  await onboardingController.markOnboardingAsComplete();
                  Get.offAllNamed(RouteHelper.getLoginRoute());
                } else {
                  onboardingController.nextPage();
                }
              },
            ),
          ),
          SizedBox(
            height: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE,
          ),

          // Skip Button
          Obx(() => TextButton(
                onPressed: () => onboardingController.skip(),
                child: Text(
                  onboardingController.currentIndex.value == _pages.length - 1
                      ? ""
                      : " Skip",
                  style: poppinsMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: Theme.of(context).primaryColor),
                ),
              )),
        ],
      ),
    );
  }
}
