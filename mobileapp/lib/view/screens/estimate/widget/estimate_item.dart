// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/estimate_controller.dart';
import 'package:invoicex/controller/transaction_controller.dart';
import 'package:invoicex/data/model/response/estimate_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/show_custom_popup_menu.dart';
import '../../home/widget/custom_horizontal_divider.dart';

class EstimateItem extends StatelessWidget {
  final EstimateModel estimateModel;
  final int index;

  const EstimateItem({
    super.key,
    required this.estimateModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final permissionData = Get.find<PermissionController>().permissionModel;
        if (permissionData!.isAppAdmin! ||
            permissionData.updateEstimates! ||
            permissionData.resendMailEstimate! ||
            permissionData.statusChangeEstimate! ||
            permissionData.invoiceConvertEstimate! ||
            permissionData.downloadEstimate! ||
            permissionData.downloadThermalEstimate! ||
            permissionData.deleteEstimates!) {
          Get.find<EstimateController>().createEstimateMoreList();
          Get.find<EstimateController>().setSelectedEstimateIndex(index);
          Get.find<EstimateController>().createEstimateMoreListPending();
          showPopupMenu(
              context,
              estimateModel.status!.name == 'Pending'
                  ? Get.find<EstimateController>().estimateMoreListPending
                  : Get.find<EstimateController>().estimateMoreList);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT - 2)),
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_LARGE,
            vertical: Dimensions.PADDING_SIZE_DEFAULT),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title item
            Text(
              Get.find<TransactionController>().beautifyText(
                estimateModel.customerName ?? '-',
              ),
              style: poppinsMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                color: Get.isDarkMode
                    ? Theme.of(context).indicatorColor
                    : LightAppColor.blackGrey,
              ),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL - 2),

            // Estimate no and date item
            Row(
              children: [
                Text(
                  estimateModel.invoiceFullNumber ?? '-',
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                CustomHorizontalDivider(
                  height: 10,
                  color: Theme.of(context).hintColor.withOpacity(0.4),
                ),
                Text(
                  estimateModel.date ?? '-',
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            // Divider item
            Divider(
              color: Theme.of(context).disabledColor.withOpacity(0.1),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            // Total and button item item
            Row(
              children: [
                Row(
                  children: [
                    // Total
                    Text(
                      "${'total_key'.tr} :  ",
                      style: poppinsMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        color: LightAppColor.darkGrey,
                      ),
                    ),

                    // Total
                    Text(
                      estimateModel.total ?? '-',
                      style: poppinsBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                        color: LightAppColor.lightGreen,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Status item
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_LARGE),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: estimateModel.status!.name == 'Reject'
                        ? LightAppColor.lightRed
                        : estimateModel.status!.name == 'Approved'
                            ? LightAppColor.lightGreen
                            : LightAppColor.lightOrange,
                  ),
                  child: Text(
                    estimateModel.status!.name == 'Reject'
                        ? 'Reject'.tr
                        : estimateModel.status!.name == 'Approved'
                            ? 'Approved'.tr
                            : 'Pending'.tr,
                    style: poppinsMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: Theme.of(context).indicatorColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
