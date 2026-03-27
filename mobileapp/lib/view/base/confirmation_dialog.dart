// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../theme/light_theme.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'custom_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? svgImagePath;
  final String? title;
  final String? description;
  final Color? descriptionColor;
  final String? leftBtnTitle;
  final String rightBtnTitle;
  final VoidCallback? leftBtnOnTap;
  final VoidCallback rightBtnOnTap;
  final Widget? titleBodyWidget;
  final double? imageHeight;

  const ConfirmationDialog({
    super.key,
    this.svgImagePath,
    this.title,
    this.description,
    this.leftBtnTitle,
    required this.rightBtnTitle,
    this.leftBtnOnTap,
    required this.rightBtnOnTap,
    this.descriptionColor,
    this.titleBodyWidget,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT + 3)),
      insetPadding:
          const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        color: Theme.of(context).cardColor,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE - 3,
                vertical: Dimensions.PADDING_SIZE_EXTRA_LARGE),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image section
                titleBodyWidget ??
                    Column(
                      children: [
                        svgImagePath != null
                            ? SvgPicture.asset(
                                svgImagePath!,
                                height: imageHeight,
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: title != null
                              ? Dimensions.PADDING_SIZE_LARGE - 2
                              : 0,
                        ),

                        // Title section
                        title != null
                            ? Text(
                                title!.tr,
                                textAlign: TextAlign.center,
                                style: poppinsBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Get.isDarkMode
                                      ? Theme.of(context).indicatorColor
                                      : LightAppColor.blackGrey,
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: title != null
                              ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                              : Dimensions.PADDING_SIZE_LARGE - 2,
                        ),

                        // Description section
                        description != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                child: Text(
                                  description!.tr,
                                  textAlign: TextAlign.center,
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    color: descriptionColor ??
                                        Theme.of(context).disabledColor,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      ],
                    ),

                // Buttons section
                GetBuilder<ExpensesController>(
                  builder: (expensesController) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (leftBtnTitle != null)
                          Expanded(
                            child: CustomButton(
                              buttonText: leftBtnTitle!.tr,
                              onPressed: leftBtnOnTap ??
                                  () {
                                    Get.back();
                                  },
                              radius: Dimensions.RADIUS_DEFAULT - 2,
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              transparent: true,
                              textColor: Get.isDarkMode
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        if (leftBtnTitle != null)
                          const SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                        leftBtnTitle != null
                            ? Expanded(
                                child: CustomButton(
                                  buttonText: rightBtnTitle.tr,
                                  buttonTextWidget:
                                      expensesController.isDialogLoading
                                          ? const Center(
                                              child: SizedBox(
                                                height: 23,
                                                width: 23,
                                                child: LoadingIndicator(
                                                  isWhiteColor: true,
                                                ),
                                              ),
                                            )
                                          : null,
                                  onPressed: expensesController.isDialogLoading
                                      ? () {}
                                      : rightBtnOnTap,
                                  radius: Dimensions.RADIUS_DEFAULT - 2,
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                  textColor: Theme.of(context).indicatorColor,
                                ),
                              )
                            : CustomButton(
                                buttonText: rightBtnTitle.tr,
                                width: 140,
                                buttonTextWidget:
                                    expensesController.isDialogLoading
                                        ? const Center(
                                            child: SizedBox(
                                              height: 23,
                                              width: 23,
                                              child: LoadingIndicator(
                                                isWhiteColor: true,
                                              ),
                                            ),
                                          )
                                        : null,
                                onPressed: expensesController.isDialogLoading
                                    ? () {}
                                    : rightBtnOnTap,
                                radius: Dimensions.RADIUS_DEFAULT - 2,
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                textColor: Theme.of(context).indicatorColor,
                              ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
