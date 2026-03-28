// ignore_for_file: deprecated_member_use

import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../controller/permission_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';

class DrawerExpandableItem extends StatelessWidget {
  const DrawerExpandableItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PermissionController>(
      builder: (permissionController) {
        createDrawerExpandableList();
        return ExpansionPanelList.radio(
          materialGapSize: 0,
          dividerColor: Colors.transparent,
          elevation: 0,
          expandedHeaderPadding: EdgeInsets.zero,
          expandIconColor: Theme.of(context).primaryColor,
          children: drawerExpandableList
              .map((item) => ExpansionPanelRadio(
                    canTapOnHeader: true,
                    value: item.title.tr,
                    backgroundColor: Colors.transparent,
                    headerBuilder: (context, isExpanded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show expandable item title
                          Row(
                            children: [
                              if (isExpanded)
                                Container(
                                  width: 5,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(
                                          Dimensions.RADIUS_DEFAULT),
                                      bottomRight: Radius.circular(
                                          Dimensions.RADIUS_DEFAULT),
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Container(
                                  color: isExpanded
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.05)
                                      : Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isExpanded
                                          ? (Dimensions.PADDING_SIZE_LARGE)
                                          : Dimensions.PADDING_SIZE_LARGE,
                                      vertical:
                                          Dimensions.PADDING_SIZE_DEFAULT),
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: .5,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          item.svgImagePath,
                                          height:
                                              Dimensions.PADDING_SIZE_DEFAULT,
                                          width:
                                              Dimensions.PADDING_SIZE_DEFAULT,
                                          fit: BoxFit.contain,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                          width: Dimensions.PADDING_SIZE_SMALL),
                                      Text(
                                        item.title.tr,
                                        style: poppinsRegular.copyWith(
                                          color: isExpanded
                                              ? Theme.of(context).primaryColor
                                              : Get.isDarkMode
                                                  ? Theme.of(context)
                                                      .indicatorColor
                                                  : Theme.of(context)
                                                      .disabledColor,
                                          fontSize:
                                              Dimensions.FONT_SIZE_DEFAULT,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },

                    // Expanded Body section
                    body: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: item.expandableItem.length,
                      padding: const EdgeInsets.only(
                          top: Dimensions.PADDING_SIZE_DEFAULT,
                          right: 0,
                          bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          left: 0),
                      itemBuilder: (context, index) {
                        final element = item.expandableItem[index];

                        // Show expandable item title
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                                width:
                                    (Dimensions.PADDING_SIZE_LARGE * 1.5) + 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: InkWell(
                                splashFactory: NoSplash.splashFactory,
                                onTap: () {
                                  Get.back();
                                  Get.toNamed(element.routePath);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_DEFAULT,
                                    horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                                  ),
                                  child: Text(
                                    element.title.tr,
                                    style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      color: Get.isDarkMode
                                          ? Theme.of(context).indicatorColor
                                          : Theme.of(context).disabledColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}

// Expandable List model
class DrawerExpandableModel {
  final String title;
  final String svgImagePath;
  final List<DrawerExpandableItemModel> expandableItem;

  DrawerExpandableModel({
    required this.title,
    required this.svgImagePath,
    required this.expandableItem,
  });
}

class DrawerExpandableItemModel {
  final String title;
  final String routePath;

  DrawerExpandableItemModel({
    required this.title,
    required this.routePath,
  });
}

List<DrawerExpandableModel> drawerExpandableList = [];

// Create drawer expandable list
createDrawerExpandableList() {
  final permissionData = Get.find<PermissionController>().permissionModel;
  drawerExpandableList = [
    if (permissionData!.isAppAdmin! ||
        permissionData.viewInvoices! ||
        permissionData.createInvoices!
    )
      DrawerExpandableModel(
        title: 'invoices_key',
        svgImagePath: Images.invoiceIcon,
        expandableItem: [
          if (permissionData.isAppAdmin! || permissionData.createInvoices!)
            DrawerExpandableItemModel(
              title: 'create_invoice_key',
              routePath: RouteHelper.createInvoiceScreen,
            ),
          if (permissionData.isAppAdmin! || permissionData.viewInvoices!)
            DrawerExpandableItemModel(
              title: 'invoices_key',
              routePath: RouteHelper.invoiceScreen,
            ),
        ],
      ),
    if ((permissionData.isAppAdmin!) ||
        (permissionData.viewExpenses! || permissionData.viewCategories!))
      DrawerExpandableModel(
        title: 'expenses_key',
        svgImagePath: Images.expensesIcon,
        expandableItem: [
          if (permissionData.isAppAdmin! || permissionData.viewExpenses!)
            DrawerExpandableItemModel(
              title: 'all_expenses_key',
              routePath: RouteHelper.expansesScreen,
            ),
          if (permissionData.isAppAdmin! || permissionData.viewCategories!)
            DrawerExpandableItemModel(
              title: 'expense_category_key',
              routePath: RouteHelper.expansesCategoryScreen,
            ),
        ],
      ),

    if ((permissionData.isAppAdmin!) || (permissionData.viewProducts! || permissionData.createProducts!))
      DrawerExpandableModel(
        title: 'wastages_key',
        svgImagePath: Images.productIcon,
        expandableItem: [
          DrawerExpandableItemModel(
            title: 'all_wastages_key',
            routePath: RouteHelper.getWastageRoute(),
          ),
        ],
      ),
    if ((permissionData.isAppAdmin!) || (permissionData.manageGlobalAccess!))
      DrawerExpandableModel(
        title: 'purchases_key',
        svgImagePath: Images.expensesIcon,
        expandableItem: [
          DrawerExpandableItemModel(
            title: 'suppliers_key',
            routePath: RouteHelper.supplierScreen,
          ),
          DrawerExpandableItemModel(
            title: 'purchase_invoices_key',
            routePath: RouteHelper.purchaseInvoicesScreen,
          ),
        ],
      ),
    if ((permissionData.isAppAdmin!) ||
        (permissionData.incomeReportView! || permissionData.expenseReportView!))
      DrawerExpandableModel(
        title: 'reports_key',
        svgImagePath: Images.reportIcon,
        expandableItem: [
          if (permissionData.isAppAdmin! || permissionData.incomeReportView!)
            DrawerExpandableItemModel(
              title: 'income_report_key',
              routePath: RouteHelper.getIncomeReportRoute(),
            ),
          if (permissionData.isAppAdmin! || permissionData.expenseReportView!)
            DrawerExpandableItemModel(
              title: 'expenses_report_key',
              routePath: RouteHelper.getExpensesReportRoute(),
            ),
        ],
      ),
  ];
}
