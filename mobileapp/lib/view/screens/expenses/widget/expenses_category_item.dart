// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/controller/transaction_controller.dart';
import 'package:invoicex/data/model/response/expenses_category_model.dart';
import 'package:invoicex/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../base/show_custom_popup_menu.dart';

class ExpensesCategoryItem extends StatelessWidget {
  const ExpensesCategoryItem({
    super.key,
    required this.data,
    required this.index,
  });

  final ExpensesCategoryModel data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesController>(builder: (expensesController) {
      return InkWell(
        onTap: () {
          final permissionData =
              Get.find<PermissionController>().permissionModel;
          if (permissionData!.isAppAdmin! ||
              permissionData.updateCategories! ||
              permissionData.deleteCategories!) {
            expensesController.createExpensesCategoryMoreList();
            expensesController.setSelectedExpensesCategoryIndex(index);
            expensesController.editCategoryController.text = data.name ?? '';
            showPopupMenu(context, expensesController.expensesCategoryMoreList);
          }
        },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_DEFAULT - 1),

              // Category name
              child: Text(
                Get.find<TransactionController>().beautifyText(
                  data.name ?? '-',
                ),
                style: poppinsRegular,
              ),
            ),
            Container(
              height: 1,
              color: Theme.of(context).disabledColor.withOpacity(.2),
            )
          ],
        ),
      );
    });
  }
}
