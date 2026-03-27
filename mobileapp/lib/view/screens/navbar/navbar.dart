// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:invoicex/controller/dashboard_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/theme/light_theme.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/screens/customer/customer_screen.dart';
import 'package:invoicex/view/screens/estimate/estimate_screen.dart';
import 'package:invoicex/view/screens/home/home_screen.dart';
import 'package:invoicex/view/screens/invoice/invoice_screen.dart';
import 'package:invoicex/view/screens/more/more_sereen_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controller/permission_controller.dart';
 import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/confirmation_dialog.dart';
 import '../notification/widget/notification_service.dart';
import '../trensaction/transactions_screen.dart';
import 'widget/tabbar_item.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _canExit = false;
  NotificationServices _notificationServices=NotificationServices();

  @override
  void initState() {
    _notificationServices.requestNotificationPermisions();
    _notificationServices.forgroundMessage();
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
    
      super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return WillPopScope(
        onWillPop: () async {
          if (Get.find<DashboardController>().bottomNavbarIndex != 0) {
            dashboardController.setBodyItem(const HomeScreen());
            Get.find<DashboardController>().setBottomNavBarIndex(0);
            return false;
          } else {
            if (_canExit) {
              return true;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('back_press_again_to_exit_key'.tr,
                    style: const TextStyle(color: Colors.white)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              ));
              _canExit = true;
              Timer(const Duration(seconds: 2), () {
                _canExit = false;
              });
              return false;
            }
          }
        },
        child: GetBuilder<PermissionController>(
          builder: (permissionController) {
            return Scaffold(
              key: scaffoldKey,
              drawer: const MoreScreenDrawer(),
              body: GetBuilder<DashboardController>(
                builder: (navbarController) {
                  return Center(child: dashboardController.bodyItem);
                },
              ),

              // bottom navbar start
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Get.isDarkMode
                          ? LightAppColor.cardColor.withOpacity(0.2)
                          : LightAppColor.darkGrey.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                ),
                child: BottomAppBar(
                  elevation: 5,
                  color: Theme.of(context).cardColor,
                  surfaceTintColor: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: permissionController.permissionModel!.isCustomer!
                        ? [
                      // Home screen Button

                      Expanded(
                        child: TabBarItem(
                          onTap: () {
                            Get.find<DashboardController>()
                                .setBottomNavBarIndex(0);
                            dashboardController
                                .setBodyItem(const HomeScreen());
                          },
                          icon: Images.home,
                          title: "home_key".tr,
                          index: 0,
                        ),
                      ),

                      // Transactions screen Button
                      Expanded(
                        child: TabBarItem(
                          onTap: () {
                            if (!permissionController.permissionLoading &&
                                (permissionController.permissionModel!
                                    .viewTransactions!)) {
                              Get.find<DashboardController>()
                                  .setBottomNavBarIndex(1);
                              dashboardController.setBodyItem(
                                  const TransactionsScreen(isCustomerScreen: false,));
                            } else if (!permissionController
                                .permissionLoading &&
                                !permissionController
                                    .permissionModel!.viewTransactions!) {
                              permissionDialog();
                            }
                          },
                          icon: Images.transactions,
                          title: "trans_key",
                          index: 1,
                        ),
                      ),

                      // Invoice screen Button
                      Expanded(
                        child: TabBarItem(
                          onTap: () {
                            if (!permissionController.permissionLoading &&
                                (permissionController
                                    .permissionModel!.viewInvoices!)) {
                              Get.find<DashboardController>()
                                  .setBottomNavBarIndex(2);
                              dashboardController
                                  .setBodyItem(InvoiceScreen(
                                isCustomerScreen: false,
                              ));
                            } else if (!permissionController
                                .permissionLoading &&
                                !permissionController
                                    .permissionModel!.viewInvoices!) {
                              permissionDialog();
                            }
                          },
                          icon: Images.invoiceIcon,
                          title: "invoices_key",
                          index: 2,
                        ),
                      ),

                      // Estimate screen Button
                      Expanded(
                        child: TabBarItem(
                          onTap: () {
                            if (!permissionController.permissionLoading &&
                                (permissionController
                                    .permissionModel!.viewEstimates!)) {
                              Get.find<DashboardController>()
                                  .setBottomNavBarIndex(3);
                              dashboardController
                                  .setBodyItem(const EstimateScreen(
                                isCustomerScreen: false,
                              ));
                            } else if (!permissionController
                                .permissionLoading &&
                                !permissionController
                                    .permissionModel!.viewEstimates!) {
                              permissionDialog();
                            }
                          },
                          icon: Images.estimatesIcon,
                          title: "estimates_key",
                          index: 3,
                        ),
                      ),

                      // More screen Button
                      Expanded(
                        child: TabBarItem(
                          onTap: () {
                            if (!permissionController.permissionLoading) {
                              scaffoldKey.currentState?.openDrawer();
                            }
                          },
                          icon: Images.more,
                          title: "more_key",
                          index: 4,
                        ),
                      ),
                    ]
                        : [
                      // Home screen Button
                      Expanded(
                        child: TabBarItem(
                          onTap: () {
                            Get.find<DashboardController>()
                                .setBottomNavBarIndex(0);
                            dashboardController
                                .setBodyItem(const HomeScreen());
                          },
                          icon: Images.home,
                          title: "home_key".tr,
                          index: 0,
                        ),
                      ),

                      // Transactions screen Button
                      Expanded(
                        child: TabBarItem(
                          onTap: () {
                            if (!permissionController.permissionLoading &&
                                (permissionController.permissionModel!.isAppAdmin! ||
                                    permissionController.permissionModel!
                                        .viewTransactions!)) {
                              Get.find<DashboardController>()
                                  .setBottomNavBarIndex(1);
                              dashboardController.setBodyItem(
                                  const TransactionsScreen(isCustomerScreen: false,));
                            } else if (!permissionController
                                .permissionLoading &&
                                !permissionController
                                    .permissionModel!.isAppAdmin! &&
                                !permissionController
                                    .permissionModel!.viewTransactions!) {
                              permissionDialog();
                            }
                          },
                          icon: Images.transactions,
                          title: "trans_key",
                          index: 1,
                        ),
                      ),

                      // Add button
                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            splashFactory: NoSplash.splashFactory,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                          ),
                          child: PopupMenuButton(
                              constraints: const BoxConstraints(
                                minWidth: double.infinity,
                              ),
                              padding: EdgeInsets.zero,
                              color: Theme.of(context).cardColor.withOpacity(
                                  0.95),
                              elevation: 0,
                              offset: Offset(
                                  150,
                                  Get.find<
                                      PermissionController>()
                                      .createCount ==
                                      0
                                      ? -345
                                      : (Get.find<
                                      PermissionController>()
                                      .createCount *
                                      -60) +
                                      (-42)),
                              // offset: const Offset(80, -345),
                              icon: Center(
                                child: SvgPicture.asset(
                                  Images.add,
                                  color: Theme.of(context).primaryColor,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              onSelected: (value) {
                                // if (value == '/addExpenses') {
                                //   Get.toNamed(
                                //       RouteHelper.getAddExpensesRoute(
                                //           '0'));
                                // } else if (value == '/addProduct') {
                                //   Get.toNamed(
                                //       RouteHelper.getAddProductRoute(
                                //           '0'));
                                // } else if (value == '/addCustomer') {
                                //   Get.toNamed(
                                //       RouteHelper.getAddCustomerRoute(
                                //           '0'));
                                // } else if (value == '/addEstimate') {
                                //   Get.toNamed(
                                //       RouteHelper.getAddEstimateRoute(
                                //           '1'));
                                // } else {
                                //   Get.toNamed(
                                //       RouteHelper.getCreateInvoiceRoute(
                                //           '1'));
                                // }
                              },
                              itemBuilder: !permissionController.permissionLoading &&
                                  (permissionController
                                      .permissionModel!.isAppAdmin! ||
                                      permissionController
                                          .permissionModel!
                                          .createInvoices! ||
                                      permissionController
                                          .permissionModel!
                                          .createEstimates! ||
                                      permissionController
                                          .permissionModel!
                                          .createExpenses! ||
                                      permissionController
                                          .permissionModel!
                                          .createProducts! ||
                                      permissionController
                                          .permissionModel!
                                          .createCustomers!)
                                  ? (_) => <PopupMenuItem<String>>[
                                if (permissionController
                                    .permissionModel!
                                    .isAppAdmin! ||
                                    permissionController
                                        .permissionModel!
                                        .createExpenses!)
                                  PopupMenuItem(
                                    value: '/addExpenses',
                                    child: Row(
                                      children: [
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                        Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                              Get.toNamed(RouteHelper
                                                  .getAddExpensesRoute(
                                                  '0'));
                                            },
                                            child: MyButton(
                                              title:
                                              'add_expenses_key'
                                                  .tr,
                                              svgImage: Images
                                                  .addExpenses,
                                              color: LightAppColor
                                                  .pink,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                      ],
                                    ),
                                  ),
                                if (permissionController
                                    .permissionModel!
                                    .isAppAdmin! ||
                                    permissionController
                                        .permissionModel!
                                        .createProducts!)
                                  PopupMenuItem(
                                    value: '/addProduct',
                                    child: Row(
                                      children: [
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                        Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                              Get.toNamed(RouteHelper
                                                  .getAddProductRoute(
                                                  '0'));
                                            },
                                            child: MyButton(
                                              title:
                                              'add_product_key'
                                                  .tr,
                                              svgImage: Images
                                                  .addProduct,
                                              color: LightAppColor
                                                  .lime,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                      ],
                                    ),
                                  ),
                                if (permissionController
                                    .permissionModel!
                                    .isAppAdmin! ||
                                    permissionController
                                        .permissionModel!
                                        .createCustomers!)
                                  PopupMenuItem(
                                    value: '/addCustomer',
                                    child: Row(
                                      children: [
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                        Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                              Get.toNamed(RouteHelper
                                                  .getAddCustomerRoute(
                                                  '0'));
                                            },
                                            child: MyButton(
                                              title:
                                              'add_customer_key'
                                                  .tr,
                                              svgImage: Images
                                                  .addCustomer,
                                              color: Theme.of(
                                                  context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                      ],
                                    ),
                                  ),
                                if (permissionController
                                    .permissionModel!
                                    .isAppAdmin! ||
                                    permissionController
                                        .permissionModel!
                                        .createEstimates!)
                                  PopupMenuItem(
                                    value: '/addEstimate',
                                    child: Row(
                                      children: [
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                        Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                              Get.toNamed(RouteHelper
                                                  .getAddEstimateRoute(
                                                  '1'));
                                            },
                                            child: MyButton(
                                              title:
                                              'add_estimate_key'
                                                  .tr,
                                              svgImage: Images
                                                  .addEstimate,
                                              color: LightAppColor
                                                  .lightOrange,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                      ],
                                    ),
                                  ),
                                if (permissionController
                                    .permissionModel!
                                    .isAppAdmin! ||
                                    permissionController
                                        .permissionModel!
                                        .createInvoices!)
                                  PopupMenuItem(
                                    value: '/createInvoice',
                                    child: Row(
                                      children: [
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                        Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                              Get.toNamed(RouteHelper
                                                  .getCreateInvoiceRoute(
                                                  '1'));
                                            },
                                            child: MyButton(
                                              title:
                                              'create_invoice_key'
                                                  .tr,
                                              svgImage: Images
                                                  .createInvoice,
                                              color: LightAppColor
                                                  .dodgerBlue,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                            flex: 2,
                                            child: SizedBox()),
                                      ],
                                    ),
                                  ),
                              ]
                                  : (_) => <PopupMenuItem<String>>[]),
                        ),
                      ),

                      // Customer screen Button
                      Expanded(
                        child: TabBarItem(
                          onTap: () {
                            if (!permissionController.permissionLoading &&
                                (permissionController.permissionModel!.isAppAdmin! ||
                                    permissionController.permissionModel!
                                        .viewCustomers!)) {
                              Get.find<DashboardController>()
                                  .setBottomNavBarIndex(3);
                              dashboardController
                                  .setBodyItem(const CustomerScreen());
                            } else if (!permissionController
                                .permissionLoading &&
                                !permissionController
                                    .permissionModel!.isAppAdmin! &&
                                !permissionController
                                    .permissionModel!.viewCustomers!) {
                              permissionDialog();
                            }
                          },
                          icon: Images.customer,
                          title: "customer_key",
                          index: 3,
                        ),
                      ),

                      // More screen Button
                      Expanded(
                        child: TabBarItem(
                          onTap: () {
                            if (!permissionController.permissionLoading) {
                              scaffoldKey.currentState?.openDrawer();
                            }
                          },
                          icon: Images.more,
                          title: "more_key",
                          index: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

// Permission dialog
  Future permissionDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          svgImagePath: Images.accessDeniedAlert,
          imageHeight: 65,
          title: 'permission_key',
          description: 'permission_description_key',
          rightBtnTitle: 'ok_key',
          rightBtnOnTap: () {
            Get.back();
          },
        );
      },
    );
  }
}



// My Button Widget for navbar
class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
        required this.title,
        required this.svgImage,
        required this.color});

  final String title;
  final String svgImage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT + 75),
      ),
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT,
        ),
        horizontalTitleGap: Dimensions.PADDING_SIZE_EXTRA_SMALL,

        // Image section
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          radius: 15,
          child: SvgPicture.asset(
            svgImage,
            height: 15,
            color: color,
          ),
        ),

        // Text section
        title: Text(
          title,
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.FONT_SIZE_LARGE,
            color: color,
          ),
        ),
      ),
    );
  }
}
