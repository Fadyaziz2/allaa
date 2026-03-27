// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:invoicex/controller/report_controller.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/view/base/nothing_to_show_here.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/loading_indicator.dart';
import 'widget/income_report_item.dart';

class IncomeReportScreen extends StatefulWidget {
  const IncomeReportScreen({super.key});

  @override
  State<IncomeReportScreen> createState() => _IncomeReportScreenState();
}

class _IncomeReportScreenState extends State<IncomeReportScreen> {
  final ScrollController _scrollController = ScrollController();

  // init method call
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // Pagination method call
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<ReportController>().incomeReportPaginateLoading &&
          Get.find<ReportController>().incomeReportNextPageUrl != null) {
        await Get.find<ReportController>().getIncomeReport(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Income report api call
    final permissionData = Get.find<PermissionController>().permissionModel;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ReportController>().getIncomeReport();
    });
    return Scaffold(
        // Custom app bar start
        appBar: CustomAppBar(
          isBackButtonExist: true,
          title: "income_report_key".tr,
          actions: [
            // Filter button section
            if (permissionData!.isAppAdmin! ||
                permissionData.manageGlobalAccess!)
              IconButton(
                onPressed: () {
                  Get.toNamed(RouteHelper.getIncomeReportFilterRoute());
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
        body: GetBuilder<ReportController>(builder: (reportController) {
          return reportController.incomeReportListLoading
              ? const Center(
                  child: LoadingIndicator(),
                )
              : reportController.incomeReportList.isEmpty
                  ? const NothingToShowHere()
                  : Column(
                      children: [
                        // Show income report list
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL),
                            itemCount: reportController.incomeReportList.length,
                            itemBuilder: (context, index) => IncomeReportItem(
                              incomeReportModel: reportController.incomeReportList[index],
                            ),
                          ),
                        ),

                        // Show income report pagination loading indicator
                        if (reportController.incomeReportPaginateLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_DEFAULT),
                            child: Center(
                              child: LoadingIndicator(),
                            ),
                          )
                      ],
                    );
        }));
  }
}
