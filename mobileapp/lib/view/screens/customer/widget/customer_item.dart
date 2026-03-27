// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/customer_controller.dart';
import 'package:invoicex/data/model/response/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/theme/light_theme.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../controller/transaction_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_image.dart';
import '../../../base/show_custom_popup_menu.dart';

class CustomerItem extends StatelessWidget {
  final CustomerModel customerModel;
  const CustomerItem({super.key, required this.customerModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(
      builder: (customerController) {
        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE - 1)),
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT / 2),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE - 1),
            ),

            // tileColor: Theme.of(context).cardColor,
            contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: Dimensions.PADDING_SIZE_SMALL,
            ),
            horizontalTitleGap: Dimensions.PADDING_SIZE_SMALL,
            onTap: () {
              final permissionData =
                  Get.find<PermissionController>().permissionModel;
              if (permissionData!.isAppAdmin! ||
                  permissionData.updateCustomers! ||
                  permissionData.detailsViewCustomer! ||
                  permissionData.customerResendPortalAccess! ||
                  permissionData.deleteCustomers!) {
                customerController.createCustomerMoreList();
                customerController.setCustomerSelectedId(
                    id: customerModel.id!,
                    status: customerModel.status!.name == "Active"
                        ? "status_inactive"
                        : "status_active");
                showPopupMenu(context, customerController.customerMoreList);
              }
            },
            leading: CircleAvatar(
              radius: Dimensions.RADIUS_EXTRA_LARGE,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
              child: customerModel.profilePictureUrl != null
                  ? ClipOval(
                      child: CustomImage(
                        image: customerModel.profilePictureUrl!,
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
                            .getFirstTwoCapitalLetters(
                                customerModel.fullName.toString()),
                        style: poppinsBold.copyWith(
                          color: Theme.of(context).indicatorColor,
                        ),
                      ),
                    ),
            ),

            // title
            title: Text(
              Get.find<TransactionController>()
                  .beautifyText(customerModel.fullName.toString()),
              maxLines: 2,
              style: poppinsMedium.copyWith(
                  overflow: TextOverflow.ellipsis,
                  fontSize: Dimensions.FONT_SIZE_DEFAULT),
            ),

            // subtitle
            subtitle: Text(
              customerModel.email.toString(),
              maxLines: 1,
              style: poppinsRegular.copyWith(
                  overflow: TextOverflow.ellipsis,
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                  color: Theme.of(context).hintColor),
            ),

            // trailing
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL - 3),
              decoration: BoxDecoration(
                color: customerModel.status!.name == "Active"
                    ? const Color(0xff6DC38D)
                    : customerModel.status!.name == "Invited"
                        ? Color(0xffff5a3d)
                        : LightAppColor.lightRed,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                customerModel.status!.name.toString().tr,
                textAlign: TextAlign.center,
                style: poppinsMedium.copyWith(
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                  color: Theme.of(context).indicatorColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
