// ignore_for_file: deprecated_member_use
import 'package:invoicex/controller/taxes_controller.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/custom_button.dart';
import 'package:invoicex/view/base/custom_snackbar.dart';
import 'package:invoicex/view/base/custom_text_field.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaxesDialog extends StatelessWidget {
  AddTaxesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<TaxesController>().refreshData(isUpdate: false);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          width: 500,
          child: GetBuilder<TaxesController>(builder: (taxController) {
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // free space
                  const SizedBox(
                    height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  ),

                  // Form title section
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "add_tax_key".tr,
                      style: poppinsMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.FREE_SIZE_LARGE + 1),
                    ),
                  ),

                  // free space
                  const SizedBox(
                    height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                  ),

                  // Name text field section
                  CustomTextField(
                    header: 'name_key'.tr,
                    isRequired: true,
                    hintText: 'enter_tax_name_key'.tr,
                    controller: taxController.taxNameController,
                    focusNode: taxController.taxNameFocusNode,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    nextFocus: taxController.taxRateFocusNode,
                  ),

                  // free space
                  const SizedBox(
                    height: Dimensions.PADDING_SIZE_DEFAULT,
                  ),

                  //  Note section
                  CustomTextField(
                    header: 'taxes_rate_key'.tr,
                    isRequired: true,
                    hintText: 'enter_tax_rate_key'.tr,
                    controller: taxController.taxRateController,
                    focusNode: taxController.taxRateFocusNode,
                    inputType: TextInputType.numberWithOptions(decimal: true),
                    isOnlyNumber: true,
                    inputAction: TextInputAction.done,
                  ),

                  // free space
                  const SizedBox(
                    height: Dimensions.PADDING_SIZE_DEFAULT,
                  ),

                  //  Button section
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: CustomButton(
                          radius: Dimensions.RADIUS_DEFAULT - 2,
                          transparent: true,
                          onPressed: () {
                            Get.back();
                          },
                          buttonText: "cancel_key".tr,
                          textColor: Get.isDarkMode
                              ? Theme.of(context).indicatorColor
                              : Theme.of(context).primaryColor,
                        ),
                      ),

                      // free space
                      const SizedBox(
                        width: Dimensions.PADDING_SIZE_SMALL,
                      ),

                      // Save button
                      Expanded(
                        child: CustomButton(
                          buttonTextWidget: taxController.addTaxLoading
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
                          onPressed: taxController.addTaxLoading
                              ? () {}
                              : () {
                                  if (taxController
                                      .taxNameController.text.isEmpty) {
                                    showCustomSnackBar(
                                        'please_enter_tax_name_key'.tr,
                                        isError: true);
                                    return;
                                  }
                                  if (taxController
                                      .taxRateController.text.isEmpty) {
                                    showCustomSnackBar(
                                        'please_enter_tax_rate_key'.tr,
                                        isError: true);
                                    return;
                                  }
                                  taxController.addTax();
                                },
                          buttonText: "save_key".tr,
                          radius: Dimensions.RADIUS_DEFAULT - 2,
                          textColor: Theme.of(context).indicatorColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
