// ignore_for_file: deprecated_member_use
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/theme/light_theme.dart';
import 'package:invoicex/util/app_constants.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/screens/more/widget/administrator_item.dart';
import 'package:invoicex/view/screens/more/widget/expandable_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../util/images.dart';
import '../../base/confirmation_dialog.dart';

class MoreScreenDrawer extends StatelessWidget {
  const MoreScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionData = Get.find<PermissionController>().permissionModel;
    return Drawer(
      surfaceTintColor:
          Get.isDarkMode ? LightAppColor.blackGrey : LightAppColor.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          // Logo start
          const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE + 50),
          GetBuilder<PermissionController>(
            builder: (permissionController) {
              return permissionController.permissionLoading
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_LARGE),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: permissionController.appLogo == null
                            ? SvgPicture.asset(
                                Images.menuLogo,
                                width: Get.width / 3,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "${AppConstants.DOMAIN_URL}${permissionController.appLogo}",
                                width: Get.width / 3,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return SvgPicture.asset(
                                    Images.menuLogo,
                                    width: Get.width / 3,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                      ),
                    );
            },
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          // Divider line
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Theme.of(context).disabledColor.withOpacity(.3),
            ),
          ),
             // Menu Item



          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const AdministratorExpandableItem(),

                  // Product Item
                  if (permissionData!.isAppAdmin! || permissionData.viewProducts!)
                    MyItem(
                      title: 'products_key'.tr,
                      imageColor: Theme.of(context).primaryColor,
                      imagePath: Images.productIcon,
                      onTap: () {
                        Get.back();
                        Get.toNamed(RouteHelper.getProductRoute());
                      },
                    ),

                  // Estimate Item
                  if (permissionData.isAppAdmin! || permissionData.viewEstimates!)
                    MyItem(
                      title: 'estimates_key'.tr,
                      imageColor: Theme.of(context).primaryColor,
                      imagePath: Images.estimatesIcon,
                      onTap: () {
                        Get.back();
                        Get.toNamed(RouteHelper.getEstimateRoute());
                      },
                    ),

                  // Dropdown Item (Expandable Item)
                  const DrawerExpandableItem(),

                  // Profile Item
                  MyItem(
                    title: 'profile_key'.tr,
                    imageColor: Theme.of(context).primaryColor,
                    imagePath: Images.userProfile,
                    isNotSvg: true,
                    onTap: () {
                      Get.back();
                      Get.toNamed(RouteHelper.getProfileRoute());
                    },
                  ),

                  // Language Item
                  MyItem(
                    title: 'change_language_key'.tr,
                    imageColor: Theme.of(context).primaryColor,
                    imagePath: Images.transactionIcon,
                    onTap: () {
                      Get.back();
                      Get.toNamed(RouteHelper.getLanguageRoute());
                    },
                  ),

                  // Setting Item
                  if (permissionData.isAppAdmin! || permissionData.viewSetting!)
                    MyItem(
                      title: 'settings_key'.tr,
                      imageColor: Theme.of(context).primaryColor,
                      imagePath: Images.settingIcon,
                      onTap: () {
                        Get.back();
                        Get.toNamed(RouteHelper.getSettingRoute());
                      },
                    ),
                ],
              ),
            ),
          ),

          // Divider line
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Theme.of(context).disabledColor.withOpacity(.3),
            ),
          ),

          // Logout Button
          MyItem(
            title: 'logout_key'.tr,
            imageColor: Theme.of(context).colorScheme.error,
            imagePath: Images.logoutIcon,
            onTap: () {
              Get.back();
              Get.dialog(
                  ConfirmationDialog(
                    imageHeight: 70,
                    svgImagePath: Images.logoutIcon,
                    title: "are_you_sure_you_want_to_logout_key".tr,
                    leftBtnTitle: 'no_key'.tr,
                    rightBtnTitle: "yes_key".tr,
                    rightBtnOnTap: () {
                      Get.find<AuthController>().clearSharedData();
                      Get.find<PermissionController>().permissionModel = null;
                      Get.offAllNamed(RouteHelper.getLoginRoute());
                    },
                    leftBtnOnTap: () {
                      Get.back();
                    },
                  ),
                  useSafeArea: false);
            },
            titleColor: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }
}

// My Item Widget for drawer list
class MyItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? imageColor;
  final Color? iconColor;
  final Color? bgColor;
  final IconData? icon;
  final Widget? child;
  final bool? isExpanded;
  final bool isNotSvg;

  const MyItem(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.onTap,
      this.titleColor,
      this.icon,
      this.imageColor,
      this.iconColor,
      this.child,
      this.isExpanded = false,
      this.bgColor,
      this.isNotSvg = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isExpanded!)
                Container(
                  width: 5,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(Dimensions.RADIUS_DEFAULT),
                      bottomRight: Radius.circular(Dimensions.RADIUS_DEFAULT),
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  color: bgColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: isExpanded!
                          ? (Dimensions.PADDING_SIZE_LARGE)
                          : Dimensions.PADDING_SIZE_LARGE,
                      vertical: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: .5,
                            color: imageColor ?? Theme.of(context).hintColor,
                          ),
                        ),
                        child: isNotSvg
                            ? Image.asset(imagePath,
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                                width: Dimensions.PADDING_SIZE_DEFAULT,
                                fit: BoxFit.contain)
                            : SvgPicture.asset(
                                imagePath,
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                                width: Dimensions.PADDING_SIZE_DEFAULT,
                                fit: BoxFit.contain,
                                color: imageColor,
                              ),
                      ),
                      const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(
                        title,
                        style: poppinsRegular.copyWith(
                          color: Get.isDarkMode
                              ? Theme.of(context).indicatorColor
                              : Theme.of(context).disabledColor,
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        ),
                      ),
                      const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      const Spacer(),
                      Icon(icon, color: iconColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
          child ?? const SizedBox()
        ],
      ),
    );
  }
}
