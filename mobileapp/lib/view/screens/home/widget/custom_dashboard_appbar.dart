// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/dashboard_controller.dart';
import 'package:invoicex/controller/notification_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../controller/theme_controller.dart';
import '../../../../util/images.dart';

class CustomDashBoardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomDashBoardAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get Notification Count
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NotificationController>().getNotificationReadStatus();
    });
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: GetBuilder<DashboardController>(builder: (dashboardController) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // profile Image
            dashboardController.profileDetailsModel != null
                ? GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getProfileRoute());
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: ClipOval(
                            child: dashboardController.profileDetailsModel!
                                            .profilePicture !=
                                        null &&
                                    dashboardController.profileDetailsModel!
                                        .profilePicture!.isNotEmpty
                                ? CustomImage(
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                    image: dashboardController
                                        .profileDetailsModel!.profilePicture!,
                                  )
                                : Image.asset(
                                    Images.userProfile,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xff71DD37),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context)
                                    .cardColor, // Set the border color
                                width: 2.0, // Set the border width
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Shimmer(
                    duration: const Duration(seconds: 2),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Get.isDarkMode
                                  ? Theme.of(context).cardColor
                                  : Colors.grey.shade200),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xff71DD37),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context)
                                    .cardColor, // Set the border color
                                width: 2.0, // Set the border width
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

            // profile name && email
            dashboardController.profileDetailsModel != null
                ? GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getProfileRoute());
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${dashboardController.profileDetailsModel!.firstName ?? ""} ${dashboardController.profileDetailsModel!.lastName ?? ""}",
                          textAlign: TextAlign.center,
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).disabledColor),
                        ),
                        Text(
                          dashboardController
                                      .profileDetailsModel!.email!.length >
                                  20
                              ? dashboardController.formatEmail(
                                  dashboardController
                                      .profileDetailsModel!.email!)
                              : dashboardController.profileDetailsModel!.email!,
                          textAlign: TextAlign.center,
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  )
                : Shimmer(
                    duration: const Duration(seconds: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Theme.of(context).cardColor
                                  : Colors.grey.shade200),
                        ),
                        const SizedBox(
                          height: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        ),
                        Container(
                          height: 13,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Theme.of(context).cardColor.withOpacity(0.5)
                                  : Colors.grey.shade200),
                        ),
                      ],
                    ),
                  ),
          ],
        );
      }),
      actions: [
        // Theme button section
        Row(
          children: [
            // Theme button
            GestureDetector(
              onTap: () {
                Get.find<ThemeController>().toggleTheme();
              },
              child: SvgPicture.asset(
                Images.dark,
                height: 22,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL - 2),

            // Notification button section
            GetBuilder<NotificationController>(
              builder: (notificationController) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getNotificationRoute());
                  },
                  child: SvgPicture.asset(
                    notificationController.notificationReadStatus
                        ? Images.notificationUnActive
                        : Images.notificationActive,

                    height: 37,
                  ),
                );
              },
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL - 2),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size(1170, GetPlatform.isDesktop ? 70 : 50);
}
