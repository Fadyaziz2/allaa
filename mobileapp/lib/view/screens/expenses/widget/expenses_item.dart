// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/controller/transaction_controller.dart';
import 'package:invoicex/data/model/response/exexpenses_model.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/screens/home/widget/custom_horizontal_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../base/show_custom_popup_menu.dart';

class ExpensesItem extends StatelessWidget {
  const ExpensesItem({super.key, required this.data, required this.index});

  final ExpensesModel data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesController>(builder: (expensesController) {
      return GestureDetector(
        onTap: () {
          final permissionData =
              Get.find<PermissionController>().permissionModel;
          if (permissionData!.isAppAdmin! ||
              permissionData.updateExpenses! ||
              permissionData.deleteExpenses!) {
            expensesController.createExpensesMoreList();
            expensesController.setSelectedExpensesIndex(index);
            showPopupMenu(context, expensesController.expensesMoreList);
          }
        },
        child: Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Get.find<TransactionController>().beautifyText(
                          data.title ?? '-',
                        ),
                        style: poppinsRegular,
                      ),
                      const SizedBox(
                        height: Dimensions.FREE_SIZE_SMALL / 2,
                      ),
                      RichText(
                        text: TextSpan(
                          text: '${"date_key".tr} : ',
                          style: poppinsRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          children: [
                            TextSpan(
                              text: data.date ?? '-',
                              style: poppinsMedium.copyWith(
                                  color: LightAppColor.darkGrey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.FREE_SIZE_DEFAULT,
                      ),
                      Container(
                        height: 25,
                        width: 140,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL,
                            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL - 3),
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.RADIUS_EXTRA_LARGE),
                          color: LightAppColor.lightGreen,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          Get.find<TransactionController>().beautifyText(
                            data.categoryName ?? '-',
                          ),
                          style: poppinsMedium.copyWith(
                            color: Theme.of(context).indicatorColor,
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),

              // Custom divider section
              const CustomHorizontalDivider(
                height: 60,
                width: 2,
              ),

              // Expenses amount section
              Expanded(
                  flex: 2,
                  child: Text(
                    data.amount ?? '-',
                    textAlign: TextAlign.end,
                    style: poppinsMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.FONT_SIZE_LARGE),
                  ))
            ],
          ),
        ),
      );
    });
  }
}
