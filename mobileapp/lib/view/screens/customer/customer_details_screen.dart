// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/customer_controller.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/styles.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/screens/customer/widget/customer_invoice_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/transaction_controller.dart';
import '../../base/custom_image.dart';
import 'widget/customer_payment_summary.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!Get.find<CustomerController>().isInvoicePaginateLoading &&
          Get.find<CustomerController>().customerInvoiceNextPageUrl != null) {
        await Get.find<CustomerController>()
            .getCustomerInvoiceDetails(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CustomerController>().getCustomerInvoiceDetails();
      Get.find<CustomerController>().getCustomerDetails();
    });
    return Scaffold(
      // Custom App Bar Section
      appBar: CustomAppBar(
        title: "customer_details_key".tr,
        isBackButtonExist: true,
      ),
      body: GetBuilder<CustomerController>(builder: (customerController) {
        return customerController.isCustomerDetailsLoading ||
                customerController.isCustomerInvoiceLoading
            ? const Center(
                child: LoadingIndicator(),
              )
            : customerController.customerDetailsModel != null
                ? SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Customer profile info section
                              Container(
                                height: 170,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                                    vertical: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).cardColor,
                                    Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.5),
                                  ], // Gradient colors
                                  begin: Alignment
                                      .topCenter, // Gradient start point
                                  end: Alignment
                                      .bottomCenter, // Gradient end point
                                )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Customer Image section
                                    customerController.customerDetailsModel!
                                                .customer!.profilePicture !=
                                            null
                                        ? ClipOval(
                                            child: CustomImage(
                                              image: customerController
                                                  .customerDetailsModel!
                                                  .customer!
                                                  .profilePicture!,
                                              height: 70,
                                              width: 70,
                                            ),
                                          )
                                        : Container(
                                            height: 70,
                                            width: 70,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: Text(
                                              Get.find<TransactionController>()
                                                  .getFirstTwoCapitalLetters(
                                                      customerController
                                                          .customerDetailsModel!
                                                          .customer!
                                                          .fullName
                                                          .toString()),
                                              style: poppinsBold.copyWith(
                                                fontSize: Dimensions
                                                        .FONT_SIZE_OVER_LARGE -
                                                    4,
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: Dimensions.PADDING_SIZE_SMALL,
                                    ),
                                    Text(
                                      customerController.customerDetailsModel!
                                              .customer!.fullName ??
                                          "name_not_added_key".tr,
                                      style: poppinsMedium.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_LARGE),
                                    ),
                                    Text(
                                      customerController.customerDetailsModel!
                                              .customer!.email ??
                                          "",
                                      style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL,
                                          color: Theme.of(context).hintColor),
                                    )
                                  ],
                                ),
                              ),

                              // Customer Payment summary section
                              Positioned(
                                bottom: -150,
                                child: CustomerPaymentSummary(
                                  customerDetailsModel:
                                      customerController.customerDetailsModel!,
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 160,
                          ),

                          // Show Customer Invoice List section
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount:
                                customerController.customerInvoiceList.length,
                            itemBuilder: (context, index) =>
                                CustomerInvoiceItem(
                              customerInvoiceDetailsModel:
                                  customerController.customerInvoiceList[index],
                            ),
                          ),

                          if (customerController.isInvoicePaginateLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_SMALL),
                              child: Center(
                                child: LoadingIndicator(),
                              ),
                            )
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                    "something_wrong_key".tr,
                    style: poppinsMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        color: Theme.of(context).disabledColor),
                  ));
      }),
    );
  }
}
