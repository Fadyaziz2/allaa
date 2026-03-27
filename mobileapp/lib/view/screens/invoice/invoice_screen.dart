// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/invoice_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/base/nothing_to_show_here.dart';
import 'package:invoicex/view/screens/invoice/widget/invoice_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';

class InvoiceScreen extends StatefulWidget {
  final bool? isCustomerScreen;
  const InvoiceScreen({super.key, this.isCustomerScreen});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
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
      if (!Get.find<InvoiceController>().invoicePaginateLoading &&
          Get.find<InvoiceController>().invoiceNextPageUrl != null) {
        await Get.find<InvoiceController>().getInvoice(isPaginate: true);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Permission Controller
    final permissionData = Get.find<PermissionController>().permissionModel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<InvoiceController>().getInvoice();
      Get.find<InvoiceController>().viewFile();
      });
    return Scaffold(
      // App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: widget.isCustomerScreen ?? true,
        title: "invoice_list_key".tr,
        actions: [
          // Add button section
          if (permissionData!.isAppAdmin! || permissionData.createInvoices!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getCreateInvoiceRoute('1'));
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
                Get.toNamed(RouteHelper.getInvoiceFilterRoute());
              },
              icon: SvgPicture.asset(
                Images.filter,
                height: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),

      // Body Section
      body: GetBuilder<InvoiceController>(
        builder: (invoiceController) {
          return invoiceController.invoiceListLoading
              ? const Center(
                  child: LoadingIndicator(),
                )
              : invoiceController.invoiceList.isEmpty
                  ? const NothingToShowHere()
                  : Column(
                      children: [
                        // Invoice List Section
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: invoiceController.invoiceList.length,
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL),
                            itemBuilder: (context, index) => InvoiceItem(
                              invoiceModel: invoiceController.invoiceList[index],
                              index: index,
                            ),
                          ),
                        ),

                        // Load More Section
                        if (invoiceController.invoicePaginateLoading)
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
