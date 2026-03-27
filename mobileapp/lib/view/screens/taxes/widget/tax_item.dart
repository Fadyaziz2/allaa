// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/controller/taxes_controller.dart';
import 'package:invoicex/controller/transaction_controller.dart';
import 'package:invoicex/data/model/response/tax_model.dart';
import 'package:invoicex/theme/light_theme.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/images.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/show_custom_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TaxItem extends StatelessWidget {
  final TaxModel data;
  final int index;
  const TaxItem({super.key, required this.index, required this.data});

  @override
  Widget build(BuildContext context) {
    bool _isArabic = Get.locale?.languageCode == 'ar';
    return GetBuilder<TaxesController>(
      builder: (taxesController) {
        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          child: GestureDetector(
            onTap: () {
              final permissionData =
                  Get.find<PermissionController>().permissionModel;
              if (permissionData!.isAppAdmin! ||
                  permissionData.updateTaxes! ||
                  permissionData.deleteTaxes!) {
                taxesController.createTaxesMoreList();
                Get.find<TaxesController>().refreshData(isUpdate: true);
                taxesController.setSelectedTaxIndex(index);
                taxesController.editTaxNameController.text = data.name ?? "";
                taxesController.editTaxRateController.text =
                    data.rate.toString();
                showPopupMenu(context, taxesController.taxesMoreList);
              }
            },
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
              ),
              tileColor: Theme.of(context).cardColor,
              contentPadding: EdgeInsets.only(
                  left: _isArabic ? 0 : Dimensions.PADDING_SIZE_SMALL,
                  top: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  right: _isArabic ? Dimensions.PADDING_SIZE_SMALL : 0),
              horizontalTitleGap: Dimensions.PADDING_SIZE_SMALL,

              // leading
              leading: CircleAvatar(
                radius: Dimensions.RADIUS_EXTRA_LARGE,
                backgroundColor: index % 2 == 0
                    ? Theme.of(context).primaryColor.withOpacity(0.15)
                    : LightAppColor.pink.withOpacity(0.15),
                child: SvgPicture.asset(
                  Images.note,
                  color: index % 2 == 0
                      ? Theme.of(context).primaryColor
                      : LightAppColor.pink,
                  height: 20,
                ),
              ),

              // title
              title: Text(
                "taxes_rate_key".tr,
                style: poppinsRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: Theme.of(context).disabledColor),
              ),

              // subtitle
              subtitle: Text(
                data.currencyWithRate.toString().tr,
                style: poppinsBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                  color: index % 2 == 0
                      ? Theme.of(context).primaryColor
                      : LightAppColor.pink,
                ),
              ),

              // trailing
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                        _isArabic ? 0 : Dimensions.RADIUS_LARGE),
                    topLeft: Radius.circular(
                        _isArabic ? 0 : Dimensions.RADIUS_LARGE),
                    topRight: Radius.circular(
                        _isArabic ? Dimensions.RADIUS_LARGE : 0),
                    bottomRight: Radius.circular(
                        _isArabic ? Dimensions.RADIUS_LARGE : 0),
                  ),
                  color: index % 2 == 0
                      ? Theme.of(context).primaryColor.withOpacity(0.15)
                      : LightAppColor.pink.withOpacity(0.15),
                ),
                child: Text(
                   Get.find<TransactionController>().beautifyText(data.name.toString().tr),
                  style: poppinsMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    color: index % 2 == 0
                        ? Theme.of(context).primaryColor
                        : LightAppColor.pink,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
