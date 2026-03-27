// ignore_for_file: deprecated_member_use

import 'package:invoicex/data/model/response/customer_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../home/widget/custom_horizontal_divider.dart';
import '../../home/widget/dashboard_item.dart';

class CustomerPaymentSummary extends StatelessWidget {
  final CustomerDetailsModel customerDetailsModel;
  const CustomerPaymentSummary({super.key, required this.customerDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.size.width - 30,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.15),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
        children: [
          // Total Amount Section
          DashBoardItem(
            icon: Images.totalAmount,
            title: "total_amount_key".tr,
            subTitle: customerDetailsModel.totalAmount.toString(),
            color: Theme.of(context).primaryColor,
            isCenter: true,
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_SMALL,
          ),
          Divider(
            color: Theme.of(context).disabledColor.withOpacity(0.1),
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_SMALL,
          ),

          // Due and Paid Section
          Row(
            children: [
              // Total Due Section
              Expanded(
                  child: DashBoardItem(
                icon: Images.totalDue,
                title: "total_due_key".tr,
                subTitle: customerDetailsModel.totalDueAmount.toString(),
                color: Theme.of(context).colorScheme.error.withOpacity(0.8),
              )),

              //  Custom Divider Section
              const CustomHorizontalDivider(),

              // Total Paid Section
              Expanded(
                  child: DashBoardItem(
                icon: Images.paidIcon,
                title: "total_paid_key".tr,
                subTitle: customerDetailsModel.totalPaidAmount.toString(),
                color: LightAppColor.aquamarine,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
