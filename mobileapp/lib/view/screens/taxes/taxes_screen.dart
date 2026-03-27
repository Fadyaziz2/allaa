// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/taxes_controller.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import 'widget/add_taxes_dialog.dart';
import 'widget/tax_item.dart';

class TaxesScreen extends StatefulWidget {
  const TaxesScreen({super.key});

  @override
  State<TaxesScreen> createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  final ScrollController _scrollController = ScrollController();
  // initialize
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // pagination logic
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<TaxesController>().taxPaginateLoading &&
          Get.find<TaxesController>().taxNextPageUrl != null) {
        await Get.find<TaxesController>().getTax(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionData = Get.find<PermissionController>().permissionModel;
    Get.find<TaxesController>().getTax();
    return Scaffold(
      // Taxes Appbar section
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "taxes_key".tr,
        actions: [
          // Add Taxes button section
          if (permissionData!.isAppAdmin! || permissionData.createTaxes!)
            IconButton(
              onPressed: () {
                Get.dialog(AddTaxesDialog());
              },
              icon: SvgPicture.asset(
                Images.addCategory,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),

      // Show Tax list section
      body: GetBuilder<TaxesController>(builder: (taxesController) {
        return taxesController.taxListLoading
            ? const Center(
                child: LoadingIndicator(),
              )
            : taxesController.taxList.isEmpty
                ? const NothingToShowHere()
                : Column(
                    children: [
                      // free space
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      // Show Tax List
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: taxesController.taxList.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          itemBuilder: (context, index) => TaxItem(
                            index: index,
                            data: taxesController.taxList[index],
                          ),
                        ),
                      ),

                      // pagination indicator
                      if (taxesController.taxPaginateLoading)
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
