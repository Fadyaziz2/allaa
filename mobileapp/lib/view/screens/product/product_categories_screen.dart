// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/controller/product_controller.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/images.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/confirmation_dialog.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/custom_snackbar.dart';
import 'package:invoicex/view/base/custom_text_field.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/base/nothing_to_show_here.dart';
import 'package:flutter_svg/svg.dart';

class ProductCategoriesScreen extends StatefulWidget {
  const ProductCategoriesScreen({super.key});

  @override
  State<ProductCategoriesScreen> createState() => _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState extends State<ProductCategoriesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductController>().getProductCategoryList();
    });
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!Get.find<ProductController>().productCategoryPaginateLoading &&
          Get.find<ProductController>().productCategoryNextPageUrl != null) {
        await Get.find<ProductController>().getProductCategoryList(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionData = Get.find<PermissionController>().permissionModel;

    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: 'product_categories_key'.tr,
        actions: [
          if (permissionData!.isAppAdmin! || permissionData.createCategories!)
            GestureDetector(
              onTap: () {
                _nameController.clear();
                showDialog(
                  context: context,
                  builder: (context) => GetBuilder<ProductController>(
                    builder: (productController) {
                      return ConfirmationDialog(
                        leftBtnTitle: 'cancel_key'.tr,
                        rightBtnTitle: 'save_key'.tr,
                        titleBodyWidget: Column(
                          children: [
                            Text('add_product_category_key'.tr, style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            CustomTextField(
                              header: 'name_key'.tr,
                              hintText: 'write_category_name_here_key'.tr,
                              controller: _nameController,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          ],
                        ),
                        rightBtnOnTap: () {
                          if (_nameController.text.trim().isEmpty) {
                            showCustomSnackBar('please_enter_the_category_name_key'.tr, isError: true);
                            return;
                          }
                          productController
                              .addProductCategory(name: _nameController.text.trim())
                              .then((value) {
                            if (value.isSuccess) {
                              Get.back();
                              showCustomSnackBar(value.message, isError: false);
                            }
                          });
                        },
                      );
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: SvgPicture.asset(Images.addCategory, color: Theme.of(context).primaryColor),
              ),
            ),
        ],
      ),
      body: GetBuilder<ProductController>(
        builder: (productController) {
          if (productController.productCategoryListLoading) {
            return const Center(child: LoadingIndicator());
          }
          if (productController.productCategoryList.isEmpty) {
            return const NothingToShowHere();
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            itemBuilder: (context, index) {
              if (index == productController.productCategoryList.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                  child: Center(child: LoadingIndicator()),
                );
              }
              return Text(
                productController.productCategoryList[index].name ?? '-',
                style: poppinsRegular,
              );
            },
            separatorBuilder: (_, __) => Divider(color: Theme.of(context).disabledColor.withOpacity(.3)),
            itemCount: productController.productCategoryList.length + (productController.productCategoryPaginateLoading ? 1 : 0),
          );
        },
      ),
    );
  }
}
