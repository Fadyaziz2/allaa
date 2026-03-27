// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/controller/dashboard_controller.dart';
import 'package:invoicex/controller/invoice_controller.dart';
import 'package:invoicex/data/model/body/due_payment_body.dart';
import 'package:invoicex/helper/date_converter.dart';
import 'package:invoicex/view/base/custom_snackbar.dart';

import '../../../../controller/payment_controller.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../controller/transaction_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_date_item.dart';
import '../../../base/custom_drop_down.dart';
import '../../../base/custom_text_field.dart';
import '../../../base/loading_indicator.dart';

class DuePaymentDialog extends StatelessWidget {
  final String previousRoute;
  const DuePaymentDialog({super.key, required this.previousRoute});

  @override
  Widget build(BuildContext context) {
    // textediting controllers
    final dueAmountController = TextEditingController();
    final payingAmountController = TextEditingController();
    final noteController = TextEditingController();

    final dueAmountFocusNode = FocusNode();
    final payingAmountFocusNode = FocusNode();
    final noteFocusNode = FocusNode();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<InvoiceController>().refreshData();
      dueAmountController.text = Get.find<InvoiceController>().formatCurrency(
          Get.find<InvoiceController>()
              .invoiceList[Get.find<InvoiceController>().selectedInvoiceIndex!]
              .dueAmount);
      Get.find<PaymentController>().getPaymentMethodsDropdownList();
    });

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          width: 500,
          child: GetBuilder<InvoiceController>(
            builder: (invoiceController) {
              // Due payment & Paying amount section
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From Title
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "due_payment_key".tr,
                        style: poppinsMedium.copyWith(
                            fontSize: Dimensions.FREE_SIZE_EXTRA_LARGE),
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_DEFAULT,
                    ),

                    // Received on
                    SelectDateItemTextField(
                      header: 'received_on_key'.tr,
                      hintText: 'select_your_date_key'.tr,
                      svgImagePath: Images.calender,
                      controller: invoiceController.duePaymentDateController,
                      onTap: () {
                        invoiceController.selectDate(context, 4);
                      },
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_DEFAULT,
                    ),

                    // Due payment & Paying amount section start
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Due payment text field section
                                CustomTextField(
                                  header: 'due_amount_key'.tr,
                                  isRequired: true,
                                  hintText: '\$0.00',
                                  readOnly: true,
                                  controller: dueAmountController,
                                  focusNode: dueAmountFocusNode,
                                  nextFocus: payingAmountFocusNode,
                                  inputType: TextInputType.number,
                                  inputAction: TextInputAction.next,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: Dimensions.PADDING_SIZE_DEFAULT,
                          ),

                          // Paying payment section start
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Paying payment field section
                                CustomTextField(
                                  header: 'paying_amount_key'.tr,
                                  isRequired: true,
                                  hintText: '\$0.00',
                                  controller: payingAmountController,
                                  focusNode: payingAmountFocusNode,
                                  inputType: TextInputType.number,
                                  inputAction: TextInputAction.done,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_DEFAULT,
                    ),

                    // Payment Method section dropdown field
                    GetBuilder<PaymentController>(builder: (paymentController) {
                      return CustomDropDown(
                        title: 'payment_method_key'.tr,
                        isRequired: true,
                        borderColor: Theme.of(context).disabledColor,
                        dwItems:
                            paymentController.paymentMethodDropdownStringList,
                        dwValue: invoiceController.paymentMethodDWValue,
                        hintText: 'choose_a_payment_method_key'.tr,
                        onChange: (value) {
                          invoiceController.setPaymentMethodDWValue(value);
                          print('object${value}');
                        },
                      );
                    }),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_DEFAULT,
                    ),

                    // Note text field section
                    CustomTextField(
                      header: 'note_key'.tr,
                      hintText: 'write_from_here_key'.tr,
                      controller: noteController,
                      focusNode: noteFocusNode,
                      inputType: TextInputType.text,
                      maxLines: 5,
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_LARGE,
                    ),

                    // Cancel and Save Button Section
                    Row(
                      children: [
                        // Cancel
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
                        )),
                        const SizedBox(
                          width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                        ),
                        // Save Button
                        Expanded(
                          child: CustomButton(
                            onPressed: invoiceController.duePaymentLoading
                                ? () {}
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      if (invoiceController
                                          .duePaymentDateController
                                          .text
                                          .isEmpty) {
                                        showCustomSnackBar(
                                            "please_select_received_on_date_key"
                                                .tr,
                                            isError: true);
                                      } else if (invoiceController
                                              .paymentMethodDWValue ==
                                          null) {
                                        showCustomSnackBar(
                                            "choose_a_payment_method_key".tr,
                                            isError: true);
                                      } else {
                                        final duePayment = DuePaymentBody(
                                          receivedOn: DateConverter
                                              .convertToDateTimeFormat(
                                                  invoiceController
                                                      .duePaymentDateController
                                                      .text),
                                          payingAmount: payingAmountController
                                              .text
                                              .trim(),
                                          paymentMethod: invoiceController
                                              .paymentMethodDWValue,
                                          note: noteController.text.trim(),
                                        );
                                        invoiceController
                                            .duePayment(
                                                duePaymentBody: duePayment)
                                            .then((value) {
                                          if (value.isSuccess) {
                                            invoiceController.getInvoice();
                                            Get.back();
                                            showCustomSnackBar(value.message,
                                                isError: false);

                                            if (Get.find<DashboardController>()
                                                    .bottomNavbarIndex ==
                                                0) {
                                              final permissionData = Get.find<
                                                      PermissionController>()
                                                  .permissionModel;
                                              if (permissionData!.isAppAdmin! ||
                                                  permissionData
                                                      .dashboardStatisticsView!) {
                                                Get.find<DashboardController>()
                                                    .getDashBoardData();
                                              }
                                              if (permissionData.isAppAdmin! ||
                                                  permissionData
                                                      .incomeOverviewDashboard!) {
                                                Get.find<DashboardController>()
                                                    .getIncomeOverview(
                                                        Get.find<DashboardController>()
                                                                .incomeOverviewFilterType[
                                                            1]['value']!,
                                                        false);
                                              }
                                              if (permissionData.isAppAdmin! ||
                                                  permissionData
                                                      .paymentOverviewDashboard!) {
                                                Get.find<DashboardController>()
                                                    .getPaymentOverviewData();
                                              }
                                            } else if (Get.find<
                                                        DashboardController>()
                                                    .bottomNavbarIndex ==
                                                1) {
                                              Get.find<TransactionController>()
                                                  .getTransaction();
                                            }
                                          }
                                        });
                                      }
                                    }
                                  },
                            buttonTextWidget:
                                invoiceController.duePaymentLoading
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
            },
          ),
        ),
      ),
    );
  }
}
