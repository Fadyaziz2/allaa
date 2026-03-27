import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/theme/light_theme.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/images.dart';
import 'widget/setting_item.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionData = Get.find<PermissionController>().permissionModel;
    return Scaffold(
      // Setting app bar
      appBar: CustomAppBar(
        title: "settings_key".tr,
        isBackButtonExist: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT),
          child: Column(
            children: [
              const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              // Payment method item
              if (permissionData!.isAppAdmin! ||
                  permissionData.viewPaymentMethods!)
                SettingItem(
                  title: "payment_method_key",
                  color: Theme.of(context).primaryColor,
                  image: Images.payment,
                  route: RouteHelper.getPaymentMethodRoute(),
                ),

              // taxes item
              if (permissionData.isAppAdmin! || permissionData.viewTaxes!)
                SettingItem(
                  title: "taxes_key",
                  color: LightAppColor.pink,
                  image: Images.taxes,
                  route: RouteHelper.getTaxesRoute(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
