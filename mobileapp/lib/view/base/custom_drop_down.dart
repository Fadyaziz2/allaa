// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/controller/transaction_controller.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomDropDown extends StatelessWidget {
  final String? dwValue;
  final List<Map<String, String>> dwItems;
  final Function(dynamic value) onChange;
  final double? width;
  final String? hintText;
  final Color? textColor;
  final Color? borderColor;
  final Color? bgColor;
  final Color? itemColor;
  final TextStyle? titleTextStyle;
  final bool isFillColor;
  final bool isBorder;
  final String? title;
  final bool isRequired;

  const CustomDropDown({
    super.key,
    required this.dwItems,
    required this.dwValue,
    required this.onChange,
    this.width,
    this.bgColor,
    this.borderColor,
    this.hintText,
    this.textColor,
    this.itemColor,
    this.titleTextStyle,
    this.isFillColor = false,
    this.isBorder = true,
    this.isRequired = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Section
        if (title != null)
          Row(
            children: [
              Text(
                title!,
                style: titleTextStyle ??
                    poppinsRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    ),
              ),
              if (isRequired)
                Text(
                  " *",
                  style: poppinsRegular.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
            ],
          ),
        SizedBox(height: title != null ? Dimensions.PADDING_SIZE_SMALL : 0),

        // Text Field Section
        SizedBox(
          height: 50,
          child: ButtonTheme(
            alignedDropdown: true,
            padding: EdgeInsets.zero,
            child: DropdownButtonFormField<String>(
              dropdownColor: Theme.of(context).cardColor,
              decoration: InputDecoration(

                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_SMALL,
                  top: Dimensions.PADDING_SIZE_DEFAULT,
                    bottom: Dimensions.PADDING_SIZE_DEFAULT,
                   ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error.withOpacity(.7),
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error.withOpacity(.7),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  borderSide: BorderSide(
                    color: Theme.of(context).disabledColor.withOpacity(.3),
                    width: 1,
                  ),
                ),
              ),
              hint: Text(
               hintText ?? '',
               style: poppinsRegular.copyWith(
                 fontSize: Dimensions.FONT_SIZE_DEFAULT,
                 color: Theme.of(context).disabledColor,
                 overflow: TextOverflow.ellipsis,
               ),
                              ),
              icon: Padding(
                padding: const EdgeInsets.only(
                    right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).disabledColor,
                ),
              ),
              isExpanded: true,
              isDense: true,

              value: dwValue,
              onChanged: (newValue) {
                onChange(newValue);
              },
              items: dwItems.map((Map<String, String> item) => DropdownMenuItem<String>(
                      value: item['id'],
                      child: Text(
                        Get.find<TransactionController>()
                            .beautifyText("${item['value']}".tr),

                        textAlign: TextAlign.start,
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
