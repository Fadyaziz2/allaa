// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controller/report_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_date_range_picker.dart';
import '../../base/loading_indicator.dart';

class ExpensesReportFilterScreen extends StatelessWidget {
  const ExpensesReportFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "filter_key".tr,
      ),

      body: GetBuilder<ExpensesController>(
        builder: (expensesController) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // free space
                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                // Filter section
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Container(
                    padding:
                        const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_DEFAULT - 2),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      children: [
                        // Date Range section
                        CustomDateRangePicker(
                          isRequired: false,
                          header: 'date_range_key'.tr,
                          hintText: 'select_date_range_key'.tr,
                          svgImagePath: Images.calender,
                          controller:
                              expensesController.expensesReportFilterController,
                          onStartTime: (startDate) {
                            expensesController.setFilterStartDate(startDate);
                          },
                          onEndTime: (endDate) {
                            expensesController.setFilterEndDate(endDate,
                                isReport: true);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // free space
                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                // Button section
                GetBuilder<ReportController>(builder: (reportController) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        // Refresh button
                        InkWell(
                          onTap: expensesController.isEmptyFilterForm() == true
                              ? () {}
                              : () {
                                  expensesController.refreshFilterForm();
                                  reportController.getExpensesReport();
                                },
                          child: Container(
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_DEFAULT),
                              border: Border.all(
                                width: 1,
                                color: expensesController.isEmptyFilterForm() ==
                                        true
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                            child: SvgPicture.asset(
                              Images.refresh,
                              color:
                                  expensesController.isEmptyFilterForm() == true
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),

                        // Free space
                        const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        // Apply button
                        Expanded(
                          child: CustomButton(
                            onPressed: reportController
                                        .expensesReportFilterLoading ||
                                    (expensesController.isEmptyFilterForm() ==
                                        true)
                                ? () {}
                                : () {
                                    reportController
                                        .getExpensesReport(fromFilter: true)
                                        .then((value) {
                                      if (value.isSuccess) {
                                        Get.back();
                                      }
                                    });
                                  },
                            buttonTextWidget:
                                reportController.expensesReportFilterLoading
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
                            color:
                                expensesController.isEmptyFilterForm() == true
                                    ? Theme.of(context).hintColor
                                    : null,
                            buttonText: 'apply_filter_key'.tr,
                            textColor:
                                expensesController.isEmptyFilterForm() == true
                                    ? Theme.of(context).disabledColor
                                    : Theme.of(context).indicatorColor,
                          ),
                        ),
                      ],
                    ),
                  );
                })
              ],
            ),
          );
        },
      ),
    );
  }
}
