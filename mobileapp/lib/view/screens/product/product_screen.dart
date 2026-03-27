// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/product_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import 'widget/product_item.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ScrollController _scrollController = ScrollController();

  // init state
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // scroll listener
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<ProductController>().isPaginateLoading &&
          Get.find<ProductController>().productsNextPageUrl != null) {
        await Get.find<ProductController>().getProducts(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get permission data
    final permissionData = Get.find<PermissionController>().permissionModel;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ProductController>().getProducts();
    });
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Scaffold(
          // App Bar Start  If product available then Appbar visible otherwise invisible
          appBar: CustomAppBar(
            isBackButtonExist: true,
            title: "product_list_key".tr,
            actions: [
              // Add button section
              if (permissionData!.isAppAdmin! || permissionData.createProducts!)
                IconButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.getAddProductRoute('0'));
                  },
                  icon: SvgPicture.asset(
                    Images.addCategory,
                    height: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

              // Filter button section
              if (permissionData.isAppAdmin! ||
                  permissionData.manageGlobalAccess!)
                IconButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.getProductFilterRoute());
                  },
                  icon: SvgPicture.asset(
                    Images.filter,
                    height: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
            ],
          ),

          // Body start
          body: productController.isProductsLoading
              ? const Center(
                  child: LoadingIndicator(),
                )
              : productController.productList.isEmpty
                  ? const NothingToShowHere()
                  : Column(
                      children: [
                        // Product List Section
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL),
                            controller: _scrollController,
                            itemCount: productController.productList.length,
                            itemBuilder: (context, index) => ProductItem(
                              productModel:
                                  productController.productList[index],
                            ),
                          ),
                        ),

                        // Paginate Section
                        if (productController.isPaginateLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: Center(
                              child: LoadingIndicator(),
                            ),
                          )
                      ],
                    ),
        );
      },
    );
  }
}
