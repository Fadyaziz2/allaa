// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/product_controller.dart';
import 'package:invoicex/controller/transaction_controller.dart';
import 'package:invoicex/data/model/response/product_model.dart';
import 'package:invoicex/view/base/show_custom_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../theme/light_theme.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../home/widget/custom_horizontal_divider.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;
  const ProductItem({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return GestureDetector(
          onTap: () {
            final permissionData =
                Get.find<PermissionController>().permissionModel;
            if (permissionData!.isAppAdmin! ||
                permissionData.updateProducts! ||
                permissionData.deleteProducts!) {
              productController.createProductMoreList();
              productController.setProductSelectedId(id: productModel.id!);
              showPopupMenu(context, productController.productMoreList);
            }
          },
          child: Container(
            width: double.infinity,
            margin:
                const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    BorderRadius.circular(Dimensions.RADIUS_DEFAULT - 2)),
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            child: Row(
              children: [
                // Product Information section start
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        Get.find<TransactionController>().beautifyText(
                          productModel.name.toString(),
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: poppinsRegular.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      ),

                      // Free space
                      const SizedBox(
                        height: Dimensions.FREE_SIZE_DEFAULT - 3,
                      ),

                      // Product code & category section
                      Row(
                        children: [
                          // Product code section
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL - 3,
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL - 3),
                              decoration: BoxDecoration(
                                  color: LightAppColor.lightGreen,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_EXTRA_LARGE)),
                              child: Text(
                                "${'sku_key'.tr}: ${productModel.sku ?? productModel.code}",
                                style: poppinsMedium.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).indicatorColor),
                              ),
                            ),
                          ),

                          // Free space
                          const SizedBox(
                            width: Dimensions.PADDING_SIZE_SMALL,
                          ),

                          // Product category section
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL - 3,
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL - 3),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: LightAppColor.lightRed,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_EXTRA_LARGE)),
                              child: Text(
                                productModel.categoryName ?? "not_added_key".tr,
                                style: poppinsMedium.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  color: LightAppColor.lightRed,
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                //Free space
                const SizedBox(
                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),

                // Custom divider section
                CustomHorizontalDivider(
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                ),

                // Free space
                const SizedBox(
                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),

                // Product category section
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 25,
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      child: Text(
                        productModel.price.toString(),
                        style: poppinsMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
