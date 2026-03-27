// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/transaction_controller.dart';
import 'package:invoicex/view/base/custom_button.dart';
import 'package:invoicex/view/base/custom_image.dart';
import 'package:invoicex/view/screens/home/widget/custom_horizontal_divider.dart';
import 'package:invoicex/view/screens/trensaction/widget/note_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../data/model/response/transaction_model.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.data});

  final TransactionModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE - 1)),
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
        children: [
          Row(
            children: [
              // Customer Image section
              data.profilePicture != null
                  ? ClipOval(
                      child: CustomImage(
                        image: data.profilePicture!,
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 45,
                      width: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        Get.find<TransactionController>()
                            .getFirstTwoCapitalLetters(data.customerName!),
                        style: poppinsBold.copyWith(
                          color: Theme.of(context).indicatorColor,
                        ),
                      ),
                    ),
              const SizedBox(
                width: Dimensions.PADDING_SIZE_SMALL,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer name
                    Text(
                      Get.find<TransactionController>().beautifyText( data.customerName ?? ''),

                      maxLines: 1,
                      style: poppinsMedium.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontSize: Dimensions.FONT_SIZE_LARGE),
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                    ),

                    // Customer received number
                    RichText(
                      text: TextSpan(
                        text: '${"received_on_key".tr}:  ',
                        style: poppinsRegular.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.FONT_SIZE_SMALL),
                        children: [
                          TextSpan(
                            text: data.receivedOn ?? '',
                            style: poppinsMedium.copyWith(
                                color: LightAppColor.darkGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: Dimensions.PADDING_SIZE_SMALL,
              ),

              // Note button
              data.note == null || data.note!.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        Get.dialog(
                          NoteDialog(body: data.note ?? ''),
                        );
                      },
                      child: Container(
                        height: 36,
                        alignment: Alignment.center,
                        width: 36,
                        padding:
                            const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                            color: LightAppColor.bisque.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(100)),
                        child: SvgPicture.asset(Images.transaction,
                            color: Theme.of(context).indicatorColor),
                      ),
                    ),
            ],
          ),
          const SizedBox(
            height: Dimensions.FREE_SIZE_EXTRA_LARGE,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).disabledColor.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
            child: Column(
              children: [
                const SizedBox(
                  height: Dimensions.FREE_SIZE_EXTRA_LARGE,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                    ),

                    // Invoice No
                    Expanded(
                      child: Text(
                        data.invoiceFullNumber ?? '',
                        textAlign: TextAlign.center,
                        style: poppinsMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: LightAppColor.lightGreen),
                      ),
                    ),
                    CustomHorizontalDivider(
                        height: 20,
                        width: 1,
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.1)),

                    // Payment no
                    Expanded(
                      child: Text(
                        data.transactionFullNumber ?? '',
                        textAlign: TextAlign.center,
                        style: poppinsMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    const SizedBox(
                      width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                    ),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.FREE_SIZE_SMALL,
                ),
                Divider(
                    color: Theme.of(context).disabledColor.withOpacity(0.1)),
                const SizedBox(
                  height: Dimensions.FREE_SIZE_SMALL,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                    ),

                    // Cash button
                    Expanded(
                      child: CustomButton(
                        width: 110,
                        height: 30,
                        textColor: Theme.of(context).indicatorColor,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                        radius: 50,
                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        onPressed: () {},
                        buttonText: data.paymentMethod ?? '',
                      ),
                    ),
                    CustomHorizontalDivider(
                        height: 40,
                        width: 1,
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.1)),

                    // Amount section
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "amount_key".tr,
                            style: poppinsMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                color: Theme.of(context).disabledColor),
                          ),
                          const SizedBox(
                            height: Dimensions.FREE_SIZE_SMALL / 2,
                          ),
                          Text(
                            data.amount ?? '',
                            style: poppinsBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: LightAppColor.lightGreen),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                    ),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.FREE_SIZE_EXTRA_LARGE,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
