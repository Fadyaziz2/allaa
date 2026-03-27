// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/customer_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import 'widget/customer_item.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    Get.find<CustomerController>().getCustomerData();
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<CustomerController>().isPaginateLoading &&
          Get.find<CustomerController>().customerNextPageUrl != null) {
        await Get.find<CustomerController>().getCustomerData(isPaginate: true);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final permissionData = Get.find<PermissionController>().permissionModel;

    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: false,
        title: "customer_list_key".tr,
        actions: [
          // Add button section
          if (permissionData!.isAppAdmin! || permissionData.createCustomers!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getAddCustomerRoute('0'));
              },
              icon: SvgPicture.asset(
                Images.addCategory,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),

          if (permissionData.isAppAdmin! || permissionData.manageGlobalAccess!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getCustomerFilterRoute());
              },
              icon: SvgPicture.asset(
                Images.filter,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),

      body: GetBuilder<CustomerController>(

          builder: (customerController) {
        return customerController.isCustomerLoading
            ? const Center(
                child: LoadingIndicator(),
              )
            : customerController.customerList.isEmpty
                ? const NothingToShowHere()
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: customerController.customerList.length,
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL,
                              vertical: Dimensions.PADDING_SIZE_SMALL),
                          itemBuilder: (context, index) => CustomerItem(
                            customerModel:
                                customerController.customerList[index],
                          ),
                        ),
                      ),
                      if (customerController.isPaginateLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Center(
                            child: LoadingIndicator(),
                          ),
                        )
                    ],
                  );
      }),
    );
  }
}
