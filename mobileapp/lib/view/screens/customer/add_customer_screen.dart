// ignore_for_file: deprecated_member_use
import 'package:invoicex/controller/customer_controller.dart';
import 'package:invoicex/controller/dashboard_controller.dart';
import 'package:invoicex/data/model/body/add_customer_body.dart';
import 'package:invoicex/view/base/custom_country_picker.dart';
import 'package:invoicex/view/base/custom_snackbar.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text_field.dart';
import 'customer_screen.dart';

class AddCustomerScreen extends StatefulWidget {
  final String isUpdate;
  const AddCustomerScreen({super.key, required this.isUpdate});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  // Textediting controllers
  final _customerFirstNameController = TextEditingController();

  final _customerLastNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _customerFirstNameFocusNode = FocusNode();

  final _customerLastNameFocusNode = FocusNode();

  final _emailFocusNode = FocusNode();

  final _phoneFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final customerController = Get.find<CustomerController>();
      customerController.refreshData();
      if (widget.isUpdate == '1') {
        customerController.getCustomerUpdateDetails().then((value) {
          if (customerController.customerUpdateDetailsModel != null) {
            _customerFirstNameController.text = customerController.customerUpdateDetailsModel!.firstName ?? "";
            _customerLastNameController.text =
                customerController.customerUpdateDetailsModel!.lastName ?? "";
            _emailController.text =
                customerController.customerUpdateDetailsModel!.email ?? "";

            customerController.setUpdatePortalAccess(
                customerController.customerUpdateDetailsModel!.portalAccess ??
                    false);
            customerController.setCountryCode(
                customerController.customerUpdateDetailsModel!.phoneCountry ??
                    "EG");
            _phoneController.text = customerController
                        .customerUpdateDetailsModel!.phoneNumber !=
                    null
                ? customerController.removeCountryCode(
                    customerController.customerUpdateDetailsModel!.phoneNumber!)
                : "";
          } else {
            customerController.setCountryCode("EG");
          }
        });
      } else {
        customerController.setCountryCode("EG");
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      // Custom App Bar Section
      appBar: CustomAppBar(
        title: widget.isUpdate == '1'
            ? "update_customer_key".tr
            : "add_customer_key".tr,
        isBackButtonExist: true,
      ),

      body: GetBuilder<CustomerController>(
        builder: (customerController) {
          return widget.isUpdate == '1' &&
                  customerController.isCustomerUpdateDetailsLoading
              ? const Center(
                  child: LoadingIndicator(),
                )
              : widget.isUpdate == '1' &&
                      customerController.customerUpdateDetailsModel == null
                  ? Center(
                      child: Text(
                        "something_wrong_key".tr,
                        style: poppinsMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            color: Theme.of(context).disabledColor),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First Name Section

                              // Customer name text field section
                              CustomTextField(
                                header: 'first_name_key'.tr,
                                isRequired: true,
                                hintText: 'customer_first_name_key'.tr,
                                controller: _customerFirstNameController,
                                focusNode: _customerFirstNameFocusNode,
                                nextFocus: _customerLastNameFocusNode,
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                fillColor: Theme.of(context).cardColor,
                              ),

                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                              ),

                              // Customer name text field section
                              CustomTextField(
                                header: 'last_name_key'.tr,
                                isRequired: true,
                                hintText: 'customer_last_name_key'.tr,
                                controller: _customerLastNameController,
                                focusNode: _customerLastNameFocusNode,
                                nextFocus: _emailFocusNode,
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                fillColor: Theme.of(context).cardColor,
                              ),

                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                              ),

                              // Customer Email text field section
                              CustomTextField(
                                header: 'email_key'.tr,
                                isRequired: false,
                                hintText: 'customer_email_key'.tr,
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                nextFocus: _phoneFocusNode,
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                fillColor: Theme.of(context).cardColor,
                              ),

                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                              ),

                              // Phone Section Start

                              CustomCountryPicker(
                                header: 'phone_number_key'.tr,
                                hintText: 'enter_phone_number_key'.tr,
                                inputAction: TextInputAction.next,
                                fillColor: Theme.of(context).cardColor,
                                country: customerController.customerCountry,
                                controller: _phoneController,
                                focusNode: _phoneFocusNode,
                                prefixIconOnTap: () {
                                  customerController.showPicker(context);
                                },
                              ),

                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                              ),

                              // Portal access section start
                              Text(
                                'portal_access_key'.tr,
                                style: poppinsRegular.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                ),
                              ),

                              const SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL,
                              ),

                              // User checkbox portal access
                              ListTile(
                                onTap: () => customerController
                                    .toggleAllowPortalAccess(),
                                leading: Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    checkColor:
                                        Theme.of(context).indicatorColor,
                                    activeColor: Theme.of(context).primaryColor,
                                    value: customerController.allowPortalAccess,
                                    onChanged: (bool? isChecked) =>
                                        customerController
                                            .toggleAllowPortalAccess(),
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .disabledColor, //your desire colour here
                                      width: 1,
                                    ),
                                  ),
                                ),
                                iconColor: Colors.red,
                                title: Text(
                                  'allow_portal_access_key'.tr,
                                  style: poppinsRegular.copyWith(
                                      color: Theme.of(context).disabledColor),
                                ),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                horizontalTitleGap: 0,
                              ),

                              const SizedBox(
                                height: Dimensions.FONT_SIZE_EXTRA_LARGE,
                              ),

                              // Save and Cancel button section

                              Row(
                                children: [
                                  Expanded(
                                      child: CustomButton(
                                    radius: Dimensions.RADIUS_DEFAULT - 2,
                                    transparent: true,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    buttonText: "cancel_key".tr,
                                    textColor: Get.isDarkMode
                                        ? Theme.of(context).indicatorColor
                                        : Theme.of(context).primaryColor,
                                  )),
                                  const SizedBox(
                                    width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: customerController
                                                  .isCustomerUpdateLoading ||
                                              customerController
                                                  .isCustomerLoading
                                          ? () {}
                                          : () async {
                                              if (_customerFirstNameController
                                                  .text.isEmpty) {
                                                showCustomSnackBar(
                                                    'please_enter_customer_first_name_key'
                                                        .tr,
                                                    isError: true);
                                                return;
                                              }
                                              if (_customerLastNameController
                                                  .text.isEmpty) {
                                                showCustomSnackBar(
                                                    'please_enter_customer_last_name_key'
                                                        .tr,
                                                    isError: true);
                                                return;
                                              }
                                              final customerBody = AddCustomerBody(
                                                  firstName: _customerFirstNameController.text.trim(),
                                                  lastName:
                                                      _customerLastNameController
                                                          .text
                                                          .trim(),
                                                  email: _emailController
                                                      .text
                                                      .trim(),
                                                  phoneCountry:
                                                      _phoneController
                                                              .text
                                                              .trim()
                                                              .isNotEmpty
                                                          ? customerController
                                                              .customerCountry
                                                              .countryCode
                                                          : "",
                                                  phone: _phoneController
                                                          .text
                                                          .trim()
                                                          .isNotEmpty
                                                      ? "+" +
                                                          customerController
                                                              .customerCountry
                                                              .phoneCode +
                                                          _phoneController.text
                                                              .trim()
                                                      : _phoneController.text.trim(),
                                                  portalAccess: customerController.allowPortalAccess ? '1' : '0');

                                              if (widget.isUpdate != '1') {
                                                await customerController
                                                    .addCustomer(
                                                        addCustomerBody:
                                                            customerBody)
                                                    .then(
                                                  (value) {
                                                    if (value.isSuccess) {
                                                      if (Get.find<
                                                                  DashboardController>()
                                                              .bottomNavbarIndex ==
                                                          3) {
                                                        customerController
                                                            .getCustomerData();
                                                      }
                                                      Get.back();
                                                      showCustomSnackBar(
                                                          value.message,
                                                          isError: false);
                                                      Get.find<
                                                              DashboardController>()
                                                          .setBottomNavBarIndex(
                                                              3);
                                                      Get.find<
                                                              DashboardController>()
                                                          .setBodyItem(
                                                        const CustomerScreen(),
                                                      );
                                                    }
                                                  },
                                                );
                                              } else {
                                                await customerController
                                                    .customerUpdate(
                                                        addCustomerBody:
                                                            customerBody)
                                                    .then(
                                                  (value) {
                                                    if (value.isSuccess) {
                                                      customerController
                                                          .getCustomerData();

                                                      Get.back();
                                                      showCustomSnackBar(
                                                          value.message,
                                                          isError: false);
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                      buttonText: widget.isUpdate == '1'
                                          ? "update_key".tr
                                          : "save_key".tr,
                                      textColor:
                                          Theme.of(context).indicatorColor,
                                      radius: Dimensions.RADIUS_DEFAULT - 2,
                                      buttonTextWidget: customerController
                                                  .isCustomerUpdateLoading ||
                                              customerController
                                                  .isCustomerLoading
                                          ? const Center(
                                              child: SizedBox(
                                                height: 23,
                                                width: 23,
                                                child: LoadingIndicator(
                                                  isWhiteColor: true,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
