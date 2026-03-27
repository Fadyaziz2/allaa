// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/transaction_controller.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controller/estimate_controller.dart';
import '../../../controller/payment_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_date_range_picker.dart';
import '../../base/custom_drop_down.dart';
import '../../base/loading_indicator.dart';

class TransactionFilterScreen extends StatelessWidget {
  const TransactionFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<PaymentController>().getPaymentMethodsDropdownList();
      Get.find<EstimateController>().getCustomerListDropdown();
    });

    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "filter_key".tr,
      ),

      body: GetBuilder<TransactionController>(
        builder: (transactionController) {
          return GetBuilder<EstimateController>(
            builder: (estimateController) {
              return estimateController.suggestedAllItemListLoading
                  ? LoadingIndicator()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT),
                          // filter input section
                          Container(
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_DEFAULT),
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_DEFAULT - 2),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Customer section

                                CustomDropDown(
                                  title: 'customers_key'.tr,
                                  isRequired: false,
                                  dwItems: estimateController
                                      .customerDropdownStringList,
                                  dwValue: transactionController
                                      .customerDropdownValue,
                                  hintText: 'choose_a_customer_key'.tr,
                                  onChange: (value) {
                                    transactionController
                                        .setCustomerDropdownValue(value);
                                  },
                                ),

                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT,
                                ),

                                // Payment Method section
                                GetBuilder<PaymentController>(
                                    builder: (paymentController) {
                                  return CustomDropDown(
                                    title: 'payment_method_key'.tr,
                                    isRequired: false,
                                    borderColor:
                                        Theme.of(context).disabledColor,
                                    dwItems: paymentController
                                        .paymentMethodDropdownStringList,
                                    dwValue: transactionController
                                        .paymentMethodDropdownValue,
                                    hintText: 'choose_a_payment_method_key'.tr,
                                    onChange: (value) {
                                      print(
                                          "value ${paymentController.paymentMethodDropdownStringList}");
                                      transactionController
                                          .setPaymentMethodDWValue(value);
                                    },
                                  );
                                }),

                                const SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT),

                                // Date Range section
                                CustomDateRangePicker(
                                  isRequired: false,
                                  header: 'date_range_key'.tr,
                                  hintText: 'select_date_range_key'.tr,
                                  svgImagePath: Images.calender,
                                  controller:
                                      transactionController.filterController,
                                  onStartTime: (startDate) {
                                    transactionController
                                        .setFilterStartDate(startDate);
                                  },
                                  onEndTime: (endDate) {
                                    transactionController
                                        .setFilterEndDate(endDate);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT),

                          // Button section
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: transactionController
                                              .isEmptyFilterForm() ==
                                          true
                                      ? () {}
                                      : () {
                                          transactionController
                                              .refreshFilterForm();
                                          Get.find<TransactionController>()
                                              .getTransaction();
                                        },
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_DEFAULT),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_DEFAULT),
                                      border: Border.all(
                                        width: 1,
                                        color: transactionController
                                                    .isEmptyFilterForm() ==
                                                true
                                            ? Theme.of(context).hintColor
                                            : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                      Images.refresh,
                                      color: transactionController
                                                  .isEmptyFilterForm() ==
                                              true
                                          ? Theme.of(context).hintColor
                                          : Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: Dimensions.PADDING_SIZE_SMALL),
                                Expanded(
                                  child: CustomButton(
                                    onPressed: transactionController
                                                .transactionFilterLoading ||
                                            (transactionController
                                                    .isEmptyFilterForm() ==
                                                true)
                                        ? () {}
                                        : () {
                                            transactionController
                                                .getTransaction(
                                                    fromFilter: true)
                                                .then((value) {
                                              if (value.isSuccess) {
                                                Get.back();
                                              }
                                            });
                                          },
                                    color: transactionController
                                                .isEmptyFilterForm() ==
                                            true
                                        ? Theme.of(context).hintColor
                                        : null,
                                    buttonTextWidget: transactionController
                                            .transactionFilterLoading
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
                                    buttonText: 'apply_filter_key'.tr,
                                    textColor: transactionController
                                                .isEmptyFilterForm() ==
                                            true
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).indicatorColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // free space
                          const SizedBox(
                            height: Dimensions.FREE_SIZE_LARGE,
                          ),
                        ],
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}
