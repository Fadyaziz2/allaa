// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/data/model/body/add_product_body.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/custom_button.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/product_controller.dart';
import '../../../util/dimensions.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_drop_down.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';

class AddProductScreen extends StatelessWidget {
  final String isUpdate;
  AddProductScreen({super.key, required this.isUpdate});

  // text controllers
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _productNameFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        if (isUpdate == '1') {
          // Get product details is product is update
          await Get.find<ProductController>().getProductDetails().then(
            (value) {
              if (Get.find<ProductController>().productDetailsModel != null) {
                _productNameController.text =
                    Get.find<ProductController>().productDetailsModel!.name ??
                        "";
                _priceController.text = Get.find<ProductController>()
                    .productDetailsModel!
                    .price
                    .toString();
                _codeController.text =
                    Get.find<ProductController>().productDetailsModel!.code ??
                        "";
                _descriptionController.text = Get.find<ProductController>()
                        .productDetailsModel!
                        .description ??
                    "";
              }
            },
          );
        }

        // Get category
        Get.find<ExpensesController>().getCategories(
            isUpdate: isUpdate == '1',
            categoryId: isUpdate == '1' &&
                    Get.find<ProductController>().productDetailsModel != null
                ? Get.find<ProductController>().productDetailsModel!.categoryId
                : -1,
            fromProduct: true);

        // Get units
        Get.find<ProductController>().getUnits(
            isUpdate: isUpdate == '1',
            unitId: isUpdate == '1' &&
                    Get.find<ProductController>().productDetailsModel != null
                ? Get.find<ProductController>().productDetailsModel!.unitId
                : -1);
      },
    );

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      // Custom App Bar Section
      appBar: CustomAppBar(
        title: isUpdate == '1' ? "edit_product_key".tr : "add_product_key".tr,
        isBackButtonExist: true,
      ),

      // Body Section
      body: GetBuilder<ProductController>(
        builder: (productController) {
          return (isUpdate == '1' && productController.isProductDetailsLoading)
              ? const Center(
                  child: LoadingIndicator(),
                )
              : isUpdate == '1' && productController.productDetailsModel == null
                  ? Center(
                      child: Text(
                        "something_wrong_key".tr,
                        style: poppinsMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            color: Theme.of(context).disabledColor),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT),
                        child: Column(
                          children: [
                            GetBuilder<ProductController>(
                              builder: (productController) {
                                return Form(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product name text field section
                                      CustomTextField(
                                        header: 'name_key'.tr,
                                        hintText: 'product_name_key'.tr,
                                        isRequired: true,
                                        controller: _productNameController,
                                        focusNode: _productNameFocusNode,
                                        nextFocus: _priceFocusNode,
                                        inputType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        fillColor: Theme.of(context).cardColor,
                                      ),

                                      // Free space
                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      // Product price text field section
                                      IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            // Price text field
                                            Expanded(
                                              child: CustomTextField(
                                                hintText: "price_key".tr,
                                                header: "price_key".tr,
                                                isRequired: true,
                                                controller: _priceController,
                                                focusNode: _priceFocusNode,
                                                nextFocus: _codeFocusNode,
                                                inputType: TextInputType.numberWithOptions(decimal: true),
                                                isOnlyNumber: true,
                                                inputAction:
                                                    TextInputAction.done,
                                                fillColor:
                                                    Theme.of(context).cardColor,
                                              ),
                                            ),

                                            // Free space
                                            const SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_DEFAULT,
                                            ),

                                            // Code text field
                                            Expanded(
                                              child: CustomTextField(
                                                hintText: 'code_key'.tr,
                                                header: 'code_key'.tr,
                                                isRequired: true,
                                                controller: _codeController,
                                                focusNode: _codeFocusNode,
                                                inputType: TextInputType.text,
                                                inputAction:
                                                    TextInputAction.done,
                                                fillColor:
                                                    Theme.of(context).cardColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      // Free space
                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      // Product category section
                                      GetBuilder<ExpensesController>(
                                        builder: (expensesController) {
                                          return CustomDropDown(
                                            isRequired: false,
                                            textColor: Colors.black,
                                            title: "category_key".tr,
                                            dwItems: expensesController
                                                .categoriesStringList,
                                            dwValue: expensesController
                                                .categoriesDWValue,
                                            hintText:
                                                'choose_a_category_key'.tr,
                                            onChange: (value) {
                                              expensesController
                                                  .setCategoriesDWValue(value);
                                            },
                                          );
                                        },
                                      ),

                                      // Free space
                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      // Unit section
                                      CustomDropDown(
                                        textColor: Colors.black,
                                        isRequired: false,
                                        title: "unit_key".tr,
                                        dwItems:
                                            productController.unitStringList,
                                        dwValue: productController.unitsDWValue,
                                        hintText: 'choose_a_unit_key'.tr,
                                        onChange: (value) {
                                          productController
                                              .setUnitDWValue(value);
                                        },
                                      ),

                                      // Free space
                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),

                                      // Product description text field section
                                      CustomTextField(
                                        hintText: 'product_details_key'.tr,
                                        controller: _descriptionController,
                                        focusNode: _descriptionFocusNode,
                                        header: "description_key".tr,
                                        inputType: TextInputType.text,
                                        inputAction: TextInputAction.done,
                                        maxLines: 5,
                                        fillColor: Theme.of(context).cardColor,
                                      ),

                                      // Free space
                                      const SizedBox(
                                        height: Dimensions.PADDING_SIZE_LARGE,
                                      ),

                                      // Button section
                                      Row(
                                        children: [
                                          // Cancel button
                                          Expanded(
                                            child: CustomButton(
                                              radius: Dimensions.RADIUS_DEFAULT - 2,
                                              transparent: true,
                                              onPressed: () {
                                                Get.back();
                                              },
                                              buttonText: "cancel_key".tr,
                                              textColor: Get.isDarkMode
                                                  ? Theme.of(context)
                                                      .indicatorColor
                                                  : Theme.of(context)
                                                      .primaryColor,
                                            ),
                                          ),

                                          // Free space
                                          const SizedBox(
                                            width: Dimensions
                                                .FREE_SIZE_EXTRA_LARGE,
                                          ),

                                          // Save button
                                          Expanded(
                                            child: CustomButton(
                                              buttonTextWidget: productController
                                                          .addProductLoading ||
                                                      productController
                                                          .isProductUpdateLoading
                                                  ? const Center(
                                                      child: SizedBox(
                                                        height: 23,
                                                        width: 23,
                                                        child: LoadingIndicator(
                                                          isWhiteColor: true,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                              onPressed: productController
                                                          .addProductLoading ||
                                                      productController
                                                          .isProductUpdateLoading
                                                  ? () {}
                                                  : () {
                                                      if (_productNameController
                                                          .text.isEmpty) {
                                                        showCustomSnackBar(
                                                            'please_enter_product_name_key'
                                                                .tr,
                                                            isError: true);
                                                        return;
                                                      }
                                                      if (_priceController
                                                          .text.isEmpty) {
                                                        showCustomSnackBar(
                                                            'enter_the_price_key'
                                                                .tr,
                                                            isError: true);
                                                        return;
                                                      }
                                                      if (_codeController
                                                          .text.isEmpty) {
                                                        showCustomSnackBar(
                                                            'enter_the_code_key'
                                                                .tr,
                                                            isError: true);
                                                        return;
                                                      }

                                                      final productModel = AddProductBody(
                                                          productName:
                                                              _productNameController
                                                                  .text
                                                                  .trim(),
                                                          price:
                                                              _priceController
                                                                  .text
                                                                  .trim(),
                                                          code: _codeController
                                                              .text
                                                              .trim(),
                                                          categoryId: Get.find<
                                                                      ExpensesController>()
                                                                  .categoriesDWValue ??
                                                              "",
                                                          unitId: productController
                                                                  .unitsDWValue ??
                                                              "",
                                                          description:
                                                              _descriptionController
                                                                  .text
                                                                  .trim());

                                                      if (isUpdate == '1') {
                                                        productController
                                                            .updateProduct(
                                                                addProductBody:
                                                                    productModel)
                                                            .then((value) {
                                                          if (value.isSuccess) {
                                                            Get.back();

                                                            showCustomSnackBar(
                                                                value.message,
                                                                isError: false);
                                                          }
                                                        });
                                                      } else {
                                                        productController
                                                            .addProduct(
                                                                addProductBody:
                                                                    productModel)
                                                            .then(
                                                          (value) {
                                                            if (value
                                                                .isSuccess) {
                                                              productController
                                                                  .getProducts();

                                                              Get.back();
                                                              Get.toNamed(
                                                                  RouteHelper
                                                                      .getProductRoute());

                                                              showCustomSnackBar(
                                                                  value.message,
                                                                  isError:
                                                                      false);
                                                            }
                                                          },
                                                        );
                                                      }
                                                    },
                                              buttonText: isUpdate == '1'
                                                  ? "update_key".tr
                                                  : "save_key".tr,
                                              textColor: Theme.of(context)
                                                  .indicatorColor,
                                              radius:
                                                  Dimensions.RADIUS_DEFAULT - 2,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
