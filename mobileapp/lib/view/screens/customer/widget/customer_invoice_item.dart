// ignore_for_file: deprecated_member_use

import 'package:invoicex/data/model/response/customer_invoice_detile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';
import '../../home/widget/custom_horizontal_divider.dart';

class CustomerInvoiceItem extends StatelessWidget {
  final CustomerInvoiceDetilesModel customerInvoiceDetailsModel;
  const CustomerInvoiceItem(
      {super.key, required this.customerInvoiceDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL - 4),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
      ),
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice section
                  Text(
                    customerInvoiceDetailsModel.invoiceNumber == null
                        ? "--"
                        : customerInvoiceDetailsModel.invoiceNumber.toString(),
                    maxLines: 1,
                    style: poppinsMedium.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontSize: Dimensions.FONT_SIZE_LARGE),
                  ),

                  const SizedBox(
                    height: Dimensions.FREE_SIZE_DEFAULT,
                  ),

                  Row(
                    children: [
                      Text(
                        "${"issue_key".tr}: ${customerInvoiceDetailsModel.issueDate}",
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            color: Theme.of(context).hintColor),
                      ),
                      //  Custom Divider Section
                      CustomHorizontalDivider(
                        height: 10,
                        color: Theme.of(context).hintColor.withOpacity(0.5),
                      ),
                      Text(
                        "${"Due".tr}: ${customerInvoiceDetailsModel.dueDate}",
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ],
              )),
              const SizedBox(
                width: Dimensions.PADDING_SIZE_SMALL,
              ),

              // Paid or Due Button
              CustomButton(
                width: 60,
                height: 30,
                fontSize: Dimensions.FONT_SIZE_SMALL,
                radius: 50,
                onPressed: () {},
                color: customerInvoiceDetailsModel.status!.classType == "danger"
                    ? Theme.of(context).colorScheme.error.withOpacity(0.8)
                    : LightAppColor.lightGreen,
                buttonText:
                    customerInvoiceDetailsModel.status!.name.toString().tr,
                textColor: Theme.of(context).indicatorColor,
              )
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
                        text: '${'total_key'.tr}:  ',
                        style: poppinsMedium.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontSize: Dimensions.FONT_SIZE_SMALL),
                        children: [
                          TextSpan(
                            text: customerInvoiceDetailsModel.totalAmount
                                .toString(),
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
                        text: '${'Paid'.tr}:  ',
                        style: poppinsMedium.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontSize: Dimensions.FONT_SIZE_SMALL),
                        children: [
                          TextSpan(
                            text: customerInvoiceDetailsModel.paidAmount
                                .toString(),
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

              // Due Amount
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Due".tr,
                    style: poppinsMedium.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                  Text(
                    customerInvoiceDetailsModel.dueAmount.toString(),
                    style: poppinsBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withOpacity(0.8)),
                  )
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
