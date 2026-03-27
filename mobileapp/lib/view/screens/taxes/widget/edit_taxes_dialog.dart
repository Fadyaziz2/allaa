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

class EditTaxesDialog extends StatelessWidget {
  EditTaxesDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                      "update_tax_key".tr,
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
                    controller:
                        Get.find<TaxesController>().editTaxNameController,
                    focusNode: Get.find<TaxesController>().editTaxNameNode,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    nextFocus: Get.find<TaxesController>().editTaxRateNode,
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
                    controller:
                        Get.find<TaxesController>().editTaxRateController,
                    focusNode: Get.find<TaxesController>().editTaxRateNode,
                    inputType: TextInputType.numberWithOptions(decimal: true),
                    isOnlyNumber: true,
                    inputAction: TextInputAction.done,
                  ),

                  // free space
                  const SizedBox(
                    height: Dimensions.PADDING_SIZE_DEFAULT,
                  ),

                  // Cancel and Update button section
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

                      // Update button
                      Expanded(
                        child: CustomButton(
                          buttonTextWidget: taxController.editTaxLoading
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
                          onPressed: taxController.editTaxLoading
                              ? () {}
                              : () {
                                  if (taxController
                                      .editTaxNameController.text.isEmpty) {
                                    showCustomSnackBar(
                                        'please_enter_tax_name_key'.tr,
                                        isError: true);
                                    return;
                                  }
                                  if (taxController
                                      .editTaxRateController.text.isEmpty) {
                                    showCustomSnackBar(
                                        'please_enter_tax_rate_key'.tr,
                                        isError: true);
                                    return;
                                  }
                                  taxController.editTax();
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
