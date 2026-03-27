// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/invoice_controller.dart';
import 'package:invoicex/controller/transaction_controller.dart';
import 'package:invoicex/data/model/response/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';
import '../../../base/show_custom_popup_menu.dart';
import '../../home/widget/custom_horizontal_divider.dart';

class InvoiceItem extends StatelessWidget {
  final InvoiceModel invoiceModel;
  final int index;
  const InvoiceItem({
    super.key,
    required this.invoiceModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final permissionData = Get.find<PermissionController>().permissionModel;
        if (permissionData!.isAppAdmin! ||
            permissionData.duePaymentInvoice! ||
            permissionData.customerDueInvoicePayment! ||
            permissionData.updateInvoices! ||
            permissionData.sendAttachmentInvoice! ||
            permissionData.manageInvoiceClone! ||
            permissionData.downloadInvoice! ||
            permissionData.downloadThermalInvoice! ||
            permissionData.deleteInvoices!) {
          Get.find<InvoiceController>().createInvoiceMoreList();
          Get.find<InvoiceController>().createInvoiceMoreListWithoutDue();
          Get.find<InvoiceController>().setSelectedInvoiceIndex(index);

          showPopupMenu(
              context,
              invoiceModel.status!.name == 'Due'
                  ? Get.find<InvoiceController>().invoiceMoreList
                  : Get.find<InvoiceController>().invoiceMoreListWithoutDue);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
        ),
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Customer Name
                Expanded(
                  child: Text(
                    Get.find<TransactionController>().beautifyText(invoiceModel.customerName ?? '-',),


                    maxLines: 1,
                    style: poppinsMedium.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontSize: Dimensions.FONT_SIZE_LARGE),
                  ),
                ),

                // Paid or Due Button
                CustomButton(
                    width: 60,
                    height: 30,
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    radius: 50,
                    onPressed: () {},
                    textColor: Theme.of(context).indicatorColor,
                    color: invoiceModel.status!.name == 'Due'
                        ? const Color(0xffE85B5B)
                        : LightAppColor.lightGreen,
                    buttonText: invoiceModel.status!.name == 'Due'
                        ? "Due".tr
                        : "Paid".tr)
              ],
            ),
            const SizedBox(
              height: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            Row(
              children: [
                // Invoice Number
                Expanded(
                  child: Text(
                    invoiceModel.invoiceNumber ?? "_",
                    maxLines: 1,
                    style: poppinsMedium.copyWith(
                        color: invoiceModel.status!.name == 'Due'
                            ? const Color(0xffE85B5B)
                            : LightAppColor.lightGreen,
                        overflow: TextOverflow.ellipsis,
                        fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                ),
                const SizedBox(
                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),

                Text(
                  invoiceModel.issueDate ?? '-',
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: Theme.of(context).hintColor),
                ),
                //  Custom Divider Section
                CustomHorizontalDivider(
                  height: 10,
                  color: Theme.of(context).hintColor.withOpacity(0.4),
                ),
                Text(
                  invoiceModel.dueDate ?? '-',
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: Theme.of(context).hintColor),
                ),
              ],
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Amount
                      RichText(
                        text: TextSpan(
                          text: '${'total_key'.tr}: ',
                          style: poppinsMedium.copyWith(
                              color: Theme.of(context).disabledColor,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          children: [
                            TextSpan(
                              text: invoiceModel.totalAmount ?? '-',
                              style: poppinsBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.FREE_SIZE_SMALL,
                      ),

                      // Paid Amount
                      RichText(
                        text: TextSpan(
                          text: '${'Paid'.tr}: ',
                          style: poppinsMedium.copyWith(
                              color: Theme.of(context).disabledColor,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          children: [
                            TextSpan(
                              text: invoiceModel.paidAmount ?? '-',
                              style: poppinsBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: LightAppColor.lightGreen),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Due Amount
                      Text(
                        "due_amount_key".tr,
                        style: poppinsMedium.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontSize: Dimensions.FONT_SIZE_SMALL),
                      ),
                      // Due Amount
                      Text(
                        invoiceModel.dueAmount ?? '-',
                        style: poppinsBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withOpacity(0.8)),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
