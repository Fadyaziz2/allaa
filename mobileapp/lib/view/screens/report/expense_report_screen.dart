// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/view/base/nothing_to_show_here.dart';
import 'package:invoicex/view/screens/report/widget/expenses_report_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
import '../../../controller/report_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/loading_indicator.dart';

class ExpensesReportScreen extends StatefulWidget {
  const ExpensesReportScreen({super.key});

  @override
  State<ExpensesReportScreen> createState() => _ExpensesReportScreenState();
}

class _ExpensesReportScreenState extends State<ExpensesReportScreen> {
  final ScrollController _scrollController = ScrollController();

  // init state
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // Pagination api call method
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<ReportController>().expensesReportPaginateLoading &&
          Get.find<ReportController>().expensesReportNextPageUrl != null) {
        await Get.find<ReportController>().getExpensesReport(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Expenses report api call
    final permissionData = Get.find<PermissionController>().permissionModel;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ReportController>().getExpensesReport();
    });
    return Scaffold(
      // Custom app bar start
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "expense_report_key".tr,
        actions: [
          // Filter button section
          if (permissionData!.isAppAdmin! || permissionData.manageGlobalAccess!)
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getExpensesReportFilterRoute());
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
      body: GetBuilder<ReportController>(
        builder: (reportController) {
          return reportController.expensesReportListLoading
              ? const Center(
                  child: LoadingIndicator(),
                )
              : reportController.expensesReportList.isEmpty
                  ? const NothingToShowHere()
                  : Column(
                      children: [
                        // Expenses report list show
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL),
                            itemCount:
                                reportController.expensesReportList.length,
                            itemBuilder: (context, index) => ExpensesReportItem(
                              expensesReportModel:
                                  reportController.expensesReportList[index],
                            ),
                          ),
                        ),

                        // pagination bottom loading indicator
                        if (reportController.expensesReportPaginateLoading)
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
