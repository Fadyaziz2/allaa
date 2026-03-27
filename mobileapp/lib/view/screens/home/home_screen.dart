// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:invoicex/controller/dashboard_controller.dart';
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/data/model/response/income_overview_model.dart';
import 'package:invoicex/theme/light_theme.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/screens/home/widget/dashboard_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../util/images.dart';
import 'widget/custom_dashboard_appbar.dart';
import 'widget/custom_horizontal_divider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Colors for pie chart
  List<Color> gradientColors = [
    LightAppColor.lightRed,
    LightAppColor.lightOrange
  ];

  int touchedIndex = -1;

//  init state
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Get.find<PermissionController>().getPermission();
      Get.find<DashboardController>().refreshData();
      Get.find<DashboardController>().getProfileDetails();
      final permissionData = Get.find<PermissionController>().permissionModel;
      if (permissionData!.isAppAdmin! ||
          permissionData.dashboardStatisticsView!) {
        Get.find<DashboardController>().getDashBoardData();
      }
      if (permissionData.isAppAdmin! ||
          permissionData.incomeOverviewDashboard!) {
        Get.find<DashboardController>().getIncomeOverview(
            Get.find<DashboardController>().incomeOverviewFilterType[1]
                ['value']!,
            false);
      }
      if (permissionData.isAppAdmin! ||
          permissionData.paymentOverviewDashboard!) {
        Get.find<DashboardController>().getPaymentOverviewData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissionData = Get.find<PermissionController>().permissionModel;
    return Scaffold(
      // Custom Dash Board Appbar Section
      appBar: const CustomDashBoardAppBar(),

      body: GetBuilder<PermissionController>(
        builder: (permissionController) {
          return GetBuilder<DashboardController>(
            builder: (dashboardController) {
              return permissionController.permissionLoading ||
                      dashboardController.isDashboardDataLoading ||
                      dashboardController.isIncomeOverviewLoading ||
                      dashboardController.isPaymentOverviewLoading
                  ? const Center(
                      child: LoadingIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: Column(
                          children: [
                            //  Dashboard Info section
                            if (Get.find<PermissionController>()
                                    .permissionModel!
                                    .isAppAdmin! ||
                                Get.find<PermissionController>()
                                    .permissionModel!
                                    .dashboardStatisticsView!)
                              dashboardController.dashboardInfoModel == null
                                  ? const SizedBox()
                                  : Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_LARGE)),
                                      padding: const EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_DEFAULT),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              // Total Amount Section
                                              Expanded(
                                                  child: DashBoardItem(
                                                icon: Images.totalAmount,
                                                title: "total_amount_key".tr,
                                                subTitle: dashboardController
                                                    .dashboardInfoModel!
                                                    .result!
                                                    .totalAmount!,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )),

                                              //  Custom Divider Section
                                              const CustomHorizontalDivider(),

                                              // Total Paid Section
                                              Expanded(
                                                  child: DashBoardItem(
                                                icon: Images.paidIcon,
                                                title: "total_paid_key".tr,
                                                subTitle: dashboardController
                                                    .dashboardInfoModel!
                                                    .result!
                                                    .totalPaidAmount!,
                                                color: LightAppColor.aquamarine,
                                              )),
                                            ],
                                          ),
                                          const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          Divider(
                                            color: Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.1),
                                          ),
                                          const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          Row(
                                            children: [
                                              // Total Due Section
                                              Expanded(
                                                  child: DashBoardItem(
                                                icon: Images.totalDue,
                                                title: "total_due_key".tr,
                                                subTitle: dashboardController
                                                    .dashboardInfoModel!
                                                    .result!
                                                    .totalDueAmount!,
                                                color: LightAppColor.bisque,
                                              )),

                                              //  Custom Divider Section
                                              const CustomHorizontalDivider(),

                                              // Total Customer Section
                                              permissionData!.isAppAdmin! ||
                                                      permissionData
                                                          .manageGlobalAccess!
                                                  ? Expanded(
                                                      child: DashBoardItem(
                                                        icon: Images
                                                            .totalCustomer,
                                                        title:
                                                            "total_customer_key"
                                                                .tr,
                                                        subTitle:
                                                            dashboardController
                                                                .dashboardInfoModel!
                                                                .result!
                                                                .totalCustomer!
                                                                .toString(),
                                                        color:
                                                            LightAppColor.pink,
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: DashBoardItem(
                                                      icon: Images.invoice,
                                                      title: "total_invoice_key"
                                                          .tr,
                                                      subTitle:
                                                          dashboardController
                                                              .dashboardInfoModel!
                                                              .result!
                                                              .totalInvoice!
                                                              .toString(),
                                                      color: LightAppColor.lime,
                                                    )),
                                            ],
                                          ),
                                          const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          Divider(
                                            color: Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.1),
                                          ),
                                          const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          Row(
                                            children: [
                                              // Total Product Section
                                              permissionData.isAppAdmin! ||
                                                      permissionData
                                                          .manageGlobalAccess!
                                                  ? Expanded(
                                                      child: DashBoardItem(
                                                        icon:
                                                            Images.totalProduct,
                                                        title:
                                                            "total_products_key"
                                                                .tr,
                                                        subTitle:
                                                            dashboardController
                                                                .dashboardInfoModel!
                                                                .result!
                                                                .totalProduct!
                                                                .toString(),
                                                        color: LightAppColor
                                                            .dodgerBlue,
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: DashBoardItem(
                                                        icon:
                                                            Images.paidInvoice,
                                                        title:
                                                            "paid_invoice_key"
                                                                .tr,
                                                        subTitle: dashboardController
                                                            .dashboardInfoModel!
                                                            .result!
                                                            .totalPaidInvoice!
                                                            .toString(),
                                                        color: LightAppColor
                                                            .lightOrange,
                                                      ),
                                                    ),

                                              //  Custom Divider Section
                                              const CustomHorizontalDivider(),

                                              // Total Invoice Section
                                              permissionData.isAppAdmin! ||
                                                      permissionData
                                                          .manageGlobalAccess!
                                                  ? Expanded(
                                                      child: DashBoardItem(
                                                        icon: Images.invoice,
                                                        title:
                                                            "total_invoice_key"
                                                                .tr,
                                                        subTitle:
                                                            dashboardController
                                                                .dashboardInfoModel!
                                                                .result!
                                                                .totalInvoice!
                                                                .toString(),
                                                        color:
                                                            LightAppColor.lime,
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: DashBoardItem(
                                                      icon: Images.dueInvoice,
                                                      title:
                                                          "due_invoice_key".tr,
                                                      subTitle:
                                                          dashboardController
                                                              .dashboardInfoModel!
                                                              .result!
                                                              .totalDueInvoice!
                                                              .toString(),
                                                      color: LightAppColor
                                                          .lightRed,
                                                    )),
                                            ],
                                          ),
                                          const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          if (permissionData.isAppAdmin! ||
                                              permissionData
                                                  .manageGlobalAccess!)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                  color: Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(0.1),
                                                ),
                                                const SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                ),
                                                Row(
                                                  children: [
                                                    // Paid Invoice Section
                                                    Expanded(
                                                        child: DashBoardItem(
                                                      icon: Images.paidInvoice,
                                                      title:
                                                          "paid_invoice_key".tr,
                                                      subTitle:
                                                          dashboardController
                                                              .dashboardInfoModel!
                                                              .result!
                                                              .totalPaidInvoice!
                                                              .toString(),
                                                      color: LightAppColor
                                                          .lightOrange,
                                                    )),

                                                    //  Custom Divider Section
                                                    const CustomHorizontalDivider(),

                                                    // Due Invoice Section
                                                    Expanded(
                                                        child: DashBoardItem(
                                                      icon: Images.dueInvoice,
                                                      title:
                                                          "due_invoice_key".tr,
                                                      subTitle:
                                                          dashboardController
                                                              .dashboardInfoModel!
                                                              .result!
                                                              .totalDueInvoice!
                                                              .toString(),
                                                      color: LightAppColor
                                                          .lightRed,
                                                    )),
                                                  ],
                                                ),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),

                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            //   Income Overview  Section
                            if (Get.find<PermissionController>()
                                    .permissionModel!
                                    .isAppAdmin! ||
                                Get.find<PermissionController>()
                                    .permissionModel!
                                    .incomeOverviewDashboard!)
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_LARGE)),
                                padding: const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "income_overview_key".tr,
                                            style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_DEFAULT,
                                            ),
                                          ),
                                        ),

                                        // Filter month section
                                        Container(
                                          width: 145,
                                          height: 32,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(0.3)),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_LARGE)),
                                          alignment: Alignment.center,
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            height: 32,
                                            child: DropdownButton<String>(
                                              dropdownColor:
                                                  Theme.of(context).cardColor,
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                size: 20,
                                              ),
                                              underline: const SizedBox(),
                                              value: dashboardController
                                                  .selectedIncomeOverviewType,
                                              padding: EdgeInsets.zero,
                                              isDense: true,
                                              isExpanded: true,
                                              items: dashboardController
                                                  .incomeOverviewFilterType
                                                  .map((Map<String, String>
                                                      value) {
                                                return DropdownMenuItem<String>(
                                                  value: value['title'],
                                                  child: Text(
                                                    value['title']!.tr,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        poppinsRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_SMALL,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                dashboardController
                                                    .setSelectedIncomeOverviewType(
                                                        value!);
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: Dimensions
                                          .PADDING_SIZE_EXTRA_OVER_LARGE,
                                    ),

                                    //  Income overview chart section
                                    dashboardController
                                            .isIncomeOverviewFilterLoading
                                        ? Container(
                                            height: 320,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: const LoadingIndicator(),
                                          )
                                        : IgnorePointer(
                                            ignoring: true,
                                            child: SfCartesianChart(
                                              enableAxisAnimation: true,
                                              primaryXAxis: CategoryAxis(
                                                labelStyle:
                                                    poppinsMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_SMALL,
                                                        color: Theme.of(context)
                                                            .disabledColor),
                                                maximumLabels: 31,
                                                autoScrollingDelta: 31,
                                                autoScrollingMode:
                                                    AutoScrollingMode.start,
                                              ),
                                              primaryYAxis: NumericAxis(
                                                labelStyle:
                                                    poppinsMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_SMALL,
                                                        color: Theme.of(context)
                                                            .disabledColor),
                                              ),
                                              zoomPanBehavior: ZoomPanBehavior(
                                                enablePanning: true,
                                              ),
                                              series: [
                                                StackedColumnSeries<
                                                    IncomeOverviewModel,
                                                    String>(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  dataSource:
                                                      dashboardController
                                                          .incomeOverviewList,
                                                  xValueMapper:
                                                      (IncomeOverviewModel iom,
                                                              _) =>
                                                          iom.context,
                                                  yValueMapper:
                                                      (IncomeOverviewModel iom,
                                                              _) =>
                                                          iom.income,
                                                  onPointTap: (newValue) {},
                                                )
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),

                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            //   Payment Overview  Section
                            if (Get.find<PermissionController>()
                                    .permissionModel!
                                    .isAppAdmin! ||
                                Get.find<PermissionController>()
                                    .permissionModel!
                                    .paymentOverviewDashboard!)
                              dashboardController.paymentOverviewModel == null
                                  ? const SizedBox()
                                  : Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_LARGE)),
                                      padding: const EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_DEFAULT),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Payment Overview Header and amount section
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "payment_overview_key".tr,
                                                  style: poppinsRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_DEFAULT),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "received_amount_key".tr,
                                                    style: poppinsRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    dashboardController
                                                            .paymentOverviewModel!
                                                            .result![0]
                                                            .currencyWithAmount ??
                                                        "",
                                                    style:
                                                        poppinsRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_LARGE,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                  const SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL,
                                                  ),
                                                  Text(
                                                    "due_amount_key".tr,
                                                    style:
                                                        poppinsRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_DEFAULT,
                                                      color: LightAppColor
                                                          .lightRed,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    dashboardController
                                                            .paymentOverviewModel!
                                                            .result![1]
                                                            .currencyWithAmount ??
                                                        "",
                                                    style:
                                                        poppinsRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_LARGE,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),

                                          // Payment Overview chart section
                                          AspectRatio(
                                            aspectRatio: 1.3,
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: PieChart(
                                                PieChartData(
                                                  pieTouchData: PieTouchData(
                                                    touchCallback:
                                                        (FlTouchEvent event,
                                                            pieTouchResponse) {
                                                      setState(() {
                                                        if (!event
                                                                .isInterestedForInteractions ||
                                                            pieTouchResponse ==
                                                                null ||
                                                            pieTouchResponse
                                                                    .touchedSection ==
                                                                null) {
                                                          touchedIndex = -1;
                                                          return;
                                                        }
                                                        touchedIndex =
                                                            pieTouchResponse
                                                                .touchedSection!
                                                                .touchedSectionIndex;
                                                      });
                                                    },
                                                  ),
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  sectionsSpace: 0,
                                                  centerSpaceRadius: 0,
                                                  sections: showingSections(
                                                      receivedAmount:
                                                          dashboardController
                                                                  .paymentOverviewModel!
                                                                  .result![0]
                                                                  .currencyWithAmount ??
                                                              "0",
                                                      dueAmount: dashboardController
                                                              .paymentOverviewModel!
                                                              .result![1]
                                                              .currencyWithAmount ??
                                                          "0",
                                                      receivedAmountPercentage:
                                                          dashboardController
                                                              .receivedAmountPercentage,
                                                      dueAmountPercentage:
                                                          dashboardController
                                                              .dueAmountPercentage),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Due and Receive indicator section
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Received Indicator section
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              const SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              Text(
                                                "received_key".tr,
                                                style: poppinsRegular.copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                              ),

                                              const SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_SMALL,
                                              ),

                                              // Due Indicator section
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        LightAppColor.lightRed),
                                              ),
                                              const SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              Text(
                                                "Due".tr,
                                                style: poppinsRegular.copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                          ],
                        ),
                      ),
                    );
            },
          );
        },
      ),
    );
  }

  // Payment Overview chart custom section
  List<PieChartSectionData> showingSections({
    required String receivedAmount,
    required String dueAmount,
    required double receivedAmountPercentage,
    required double dueAmountPercentage,
  }) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 110.0 : 100.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Theme.of(context).primaryColor,
            value: receivedAmountPercentage,
            title: receivedAmount,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: LightAppColor.lightRed,
            value: dueAmountPercentage,
            title: dueAmount,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgePositionPercentageOffset: .98,
          );

        default:
          throw Exception('Oh no');
      }
    });
  }
}
