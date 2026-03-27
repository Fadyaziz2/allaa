// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/data/model/response/expenses_report_model.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/screens/home/widget/custom_horizontal_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';

class ExpensesReportItem extends StatelessWidget {
  final ExpensesReportModel expensesReportModel;
  const ExpensesReportItem({super.key, required this.expensesReportModel});

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
                      expensesReportModel.title ?? "",
                      style: poppinsRegular,
                    ),

                    // free space
                    const SizedBox(
                      height: Dimensions.FREE_SIZE_SMALL / 2,
                    ),

                    // Date section
                    RichText(
                      text: TextSpan(
                        text: '${"date_key".tr} : ',
                        style: poppinsRegular.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.FONT_SIZE_SMALL),
                        children: [
                          TextSpan(
                            text: expensesReportModel.date ?? "",
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
                        expensesReportModel.amount ?? "",
                        style: poppinsMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ))
            ],
          ),
        );
      },
    );
  }
}
