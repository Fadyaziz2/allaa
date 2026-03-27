// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/data/model/response/income_report_model.dart';
import 'package:invoicex/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../home/widget/custom_horizontal_divider.dart';

class IncomeReportItem extends StatelessWidget {
  final IncomeReportModel incomeReportModel;
  const IncomeReportItem({super.key, required this.incomeReportModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesController>(
      builder: (expensesController) {
        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT,
              vertical: Dimensions.PADDING_SIZE_DEFAULT),
          child: Row(
            children: [
              // Left side details
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      incomeReportModel.customerName ?? "",
                      style: poppinsRegular,
                    ),

                    // free space
                    const SizedBox(
                      height: Dimensions.FREE_SIZE_SMALL / 2,
                    ),

                    // Date section
                    RichText(
                      text: TextSpan(
                        text: '${"issue_date_key".tr} : ',
                        style: poppinsRegular.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.FONT_SIZE_SMALL),
                        children: [
                          TextSpan(
                            text: incomeReportModel.issueDate!.toString(),
                            style: poppinsMedium.copyWith(
                                color: LightAppColor.darkGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Custom divider section
              CustomHorizontalDivider(
                color: Theme.of(context).hintColor.withOpacity(0.2),
              ),

              // Right side details
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 25,
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    child: Text(
                      incomeReportModel.receivedAmount ?? "",
                      style: poppinsMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
