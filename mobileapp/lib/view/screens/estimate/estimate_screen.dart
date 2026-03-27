// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/estimate_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/base/nothing_to_show_here.dart';
import 'package:invoicex/view/screens/estimate/widget/estimate_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';

class EstimateScreen extends StatefulWidget {
  final bool? isCustomerScreen;
  const EstimateScreen({super.key, this.isCustomerScreen});

  @override
  State<EstimateScreen> createState() => _EstimateScreenState();
}

class _EstimateScreenState extends State<EstimateScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // Scroll Listener
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<EstimateController>().estimatePaginateLoading &&
          Get.find<EstimateController>().estimateNextPageUrl != null) {
        await Get.find<EstimateController>().getEstimate(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionData = Get.find<PermissionController>().permissionModel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<EstimateController>().getEstimate();
      Get.find<EstimateController>().viewFile();
    });
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: widget.isCustomerScreen ?? true,
        title: "estimate_list_key".tr,
        actions: [
          // Add button section
          if (permissionData!.isAppAdmin! || permissionData.createEstimates!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getAddEstimateRoute('1'));
              },
              icon: SvgPicture.asset(
                Images.addCategory,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),

          // Filter button section
          if (permissionData.isAppAdmin! || permissionData.manageGlobalAccess!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getEstimateFilterRoute());
              },
              icon: SvgPicture.asset(
                Images.filter,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),

      //  Body Start
      body: GetBuilder<EstimateController>(
        builder: (estimateController) {
          return estimateController.estimateListLoading
              ? const Center(
                  child: LoadingIndicator(),
                )
              : estimateController.estimateList.isEmpty
                  ? const NothingToShowHere()
                  : Column(
                      children: [
                        // Estimate List View
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: estimateController.estimateList.length,
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL),
                            itemBuilder: (context, index) => EstimateItem(
                              estimateModel:
                                  estimateController.estimateList[index],
                              index: index,
                            ),
                          ),
                        ),

                        // Pagination loading indicator
                        if (estimateController.estimatePaginateLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_DEFAULT),
                            child: Center(
                              child: LoadingIndicator(),
                            ),
                          )
                      ],
                    );
        },
      ),
    );
  }
}
