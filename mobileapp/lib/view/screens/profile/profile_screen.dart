// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:invoicex/controller/customer_controller.dart';
import 'package:invoicex/controller/dashboard_controller.dart';
import 'package:invoicex/data/model/body/update_profile_body.dart';
import 'package:invoicex/view/base/custom_image.dart';
import 'package:invoicex/view/base/custom_snackbar.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_country_picker.dart';
import '../../base/custom_drop_down.dart';
import '../../base/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // text editing controllers
  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _addressController = TextEditingController();

  final _phoneController = TextEditingController();

  final _firstNameFocusNode = FocusNode();

  final _lastNameFocusNode = FocusNode();

  final _emailFocusNode = FocusNode();

  final _addressFocusNode = FocusNode();

  final _phoneFocusNode = FocusNode();

  // init method
  @override
  void initState() {
    super.initState();
    final dashBoardCon = Get.find<DashboardController>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        dashBoardCon.getProfileDetails().then(
          (value) {
            if (value.isSuccess) {
              dashBoardCon.pickImage(true);

              if (dashBoardCon.profileDetailsModel != null) {
                _firstNameController.text =
                    dashBoardCon.profileDetailsModel!.firstName ?? "";
                _lastNameController.text =
                    dashBoardCon.profileDetailsModel!.lastName ?? "";
                _emailController.text =
                    dashBoardCon.profileDetailsModel!.email ?? "";

                _addressController.text =
                    dashBoardCon.profileDetailsModel!.address ?? "";
                dashBoardCon.setGender(
                    dashBoardCon.profileDetailsModel!.gender?.capitalizeFirst,
                    false);
                dashBoardCon.setCountryCode(
                    dashBoardCon.profileDetailsModel!.phoneCountry ?? "US");
                _phoneController.text =
                    dashBoardCon.profileDetailsModel!.phoneNumber != null
                        ? dashBoardCon.removeCountryCode(
                            dashBoardCon.profileDetailsModel!.phoneNumber!)
                        : "";
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      // Profile App bar section
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "edit_profile_key".tr,
      ),

      // Body section
      body: GetBuilder<DashboardController>(
        builder: (dashboardController) {
          return Column(
            children: [
              // Profile Details section
              Expanded(
                child: dashboardController.isProfileDetailsLoading
                    ? const Center(
                        child: LoadingIndicator(),
                      )
                    : dashboardController.profileDetailsModel == null
                        ? Center(
                            child: Text(
                              "something_wrong_key".tr,
                              style: poppinsMedium.copyWith(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: Dimensions.FONT_SIZE_SMALL),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // free space
                                  const SizedBox(
                                    height: Dimensions.PADDING_SIZE_SMALL,
                                  ),

                                  // Profile picture section
                                  Align(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.none,
                                      children: [
                                        // Circle profile image
                                        ClipOval(
                                          child: dashboardController
                                                      .pickedImage !=
                                                  null
                                              ? Image.file(
                                                  File(dashboardController
                                                      .pickedImage!.path),
                                                  height: 120,
                                                  width: 120,
                                                  fit: BoxFit.cover,
                                                )
                                              : dashboardController
                                                          .profileDetailsModel!
                                                          .profilePicture !=
                                                      null
                                                  ? ClipOval(
                                                      child: CustomImage(
                                                          height: 120,
                                                          width: 120,
                                                          fit: BoxFit.cover,
                                                          image: dashboardController
                                                              .profileDetailsModel!
                                                              .profilePicture!),
                                                    )
                                                  : SizedBox(
                                                      height: 120,
                                                      width: 120,
                                                      child: ClipOval(
                                                        child: Image.asset(
                                                          Images.userProfile,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                        ),

                                        // Profile image outline border
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 4,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            ),
                                          ),
                                        ),

                                        // Edit profile image section
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              dashboardController
                                                  .pickImage(false);
                                            },
                                            child: Container(
                                                height: 35,
                                                width: 35,
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                            .PADDING_SIZE_SMALL -
                                                        2),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Theme.of(context)
                                                          .cardColor),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: SvgPicture.asset(
                                                  Images.editProfile,
                                                  color: Theme.of(context)
                                                      .indicatorColor,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // free space
                                  const SizedBox(
                                    height: Dimensions.PADDING_SIZE_SMALL,
                                  ),

                                  // Name text field section
                                  CustomTextField(
                                    header: "first_name_key".tr,
                                    isRequired: true,
                                    hintText: 'enter_your_first_name_key'.tr,
                                    controller: _firstNameController,
                                    focusNode: _firstNameFocusNode,
                                    inputType: TextInputType.text,
                                    fillColor: Theme.of(context).cardColor,
                                    inputAction: TextInputAction.next,
                                    nextFocus: _lastNameFocusNode,
                                  ),

                                  // free space
                                  const SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT,
                                  ),

                                  // Name text field section
                                  CustomTextField(
                                    header: 'last_name_key'.tr,
                                    isRequired: true,
                                    hintText: 'enter_your_last_name_key'.tr,
                                    controller: _lastNameController,
                                    focusNode: _lastNameFocusNode,
                                    inputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    nextFocus: _emailFocusNode,
                                    fillColor: Theme.of(context).cardColor,
                                  ),

                                  // free space
                                  const SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT,
                                  ),

                                  // Email text field section
                                  CustomTextField(
                                    header: 'email_address_key'.tr,
                                    isRequired: true,
                                    hintText: 'enter_your_email_key'.tr,
                                    controller: _emailController,
                                    focusNode: _emailFocusNode,
                                    inputType: TextInputType.emailAddress,
                                    inputAction: TextInputAction.done,
                                    fillColor: Theme.of(context).cardColor,
                                  ),

                                  // free space
                                  const SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT,
                                  ),

                                  // Phone Section Start
                                  GetBuilder<CustomerController>(
                                    builder: (customerController) {
                                      return CustomCountryPicker(
                                        header: 'phone_number_key'.tr,
                                        hintText: 'enter_phone_number_key'.tr,
                                        inputAction: TextInputAction.next,
                                        country: dashboardController.country,
                                        fillColor: Theme.of(context).cardColor,
                                        controller: _phoneController,
                                        focusNode: _phoneFocusNode,
                                        prefixIconOnTap: () {
                                          customerController.showPicker(context,
                                              fromProfile: true);
                                        },
                                      );
                                    },
                                  ),

                                  // free space
                                  const SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT,
                                  ),

                                  // Gender section dropdown
                                  CustomDropDown(
                                    title: 'gender_key'.tr,
                                    isRequired: true,
                                    dwItems: dashboardController.genderList,
                                    dwValue: dashboardController.selectedGender,
                                    hintText: 'choose_a_gender_key'.tr,
                                    borderColor: Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.5),
                                    onChange: (value) {
                                      dashboardController.setGender(
                                          value, true);
                                    },
                                  ),

                                  // free space
                                  const SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT,
                                  ),

                                  // Address text field section
                                  CustomTextField(
                                    header: 'address_key'.tr,
                                    isRequired: false,
                                    hintText: 'address_key'.tr,
                                    controller: _addressController,
                                    focusNode: _addressFocusNode,
                                    inputType: TextInputType.streetAddress,
                                    inputAction: TextInputAction.done,
                                    fillColor: Theme.of(context).cardColor,
                                    maxLines: 5,
                                  ),
                                  // free space
                                  const SizedBox(
                                    height: Dimensions.PADDING_SIZE_LARGE,
                                  ),

                                  // Update Button Section
                                  Row(
                                    children: [
                                      // Cancel Button
                                      Expanded(
                                        child: CustomButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          transparent: true,
                                          buttonText: "cancel_key".tr,
                                          textColor: Get.isDarkMode
                                              ? Theme.of(context).indicatorColor
                                              : Theme.of(context).primaryColor,
                                          radius: Dimensions.RADIUS_DEFAULT - 2,
                                        ),
                                      ),

                                      // free space
                                      const SizedBox(
                                        width: Dimensions.FREE_SIZE_EXTRA_LARGE,
                                      ),

                                      // Update Button
                                      Expanded(
                                        child: CustomButton(
                                          radius: Dimensions.RADIUS_DEFAULT - 2,
                                          transparent: false,
                                          buttonTextWidget: dashboardController
                                                  .updateProfileLoading
                                              ? const Center(
                                                  child: SizedBox(
                                                    height: 23,
                                                    width: 23,
                                                    child: LoadingIndicator(
                                                        isWhiteColor: true),
                                                  ),
                                                )
                                              : null,
                                          onPressed: () {
                                            if (_firstNameController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBar(
                                                  'please_enter_your_first_name_key'
                                                      .tr,
                                                  isError: true);
                                            } else if (_lastNameController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBar(
                                                  'please_enter_your_last_name_key'
                                                      .tr,
                                                  isError: true);
                                            } else if (_emailController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBar(
                                                  'please_enter_email_address_key'
                                                      .tr,
                                                  isError: true);
                                            } else if (dashboardController
                                                    .selectedGender ==
                                                null) {
                                              showCustomSnackBar(
                                                  "please_choose_a_gender_key"
                                                      .tr,
                                                  isError: true);
                                            } else {
                                              final profileModel = UpdateProfileBody(
                                                  firstName:
                                                      _firstNameController.text
                                                          .trim(),
                                                  lastName: _lastNameController.text
                                                      .trim(),
                                                  email: _emailController.text
                                                      .trim(),
                                                  phoneCountry: _phoneController
                                                          .text
                                                          .trim()
                                                          .isNotEmpty
                                                      ? dashboardController
                                                          .country.countryCode
                                                      : "",
                                                  phone: _phoneController.text
                                                          .trim()
                                                          .isNotEmpty
                                                      ? "+" +
                                                          dashboardController
                                                              .country
                                                              .phoneCode +
                                                          _phoneController.text
                                                      : _phoneController.text
                                                          .trim(),
                                                  gender: dashboardController
                                                      .selectedGender!
                                                      .toLowerCase(),
                                                  address: _addressController
                                                      .text
                                                      .trim());

                                              dashboardController
                                                  .updateProfile(profileModel)
                                                  .then((value) {
                                                if (value.isSuccess) {
                                                  Get.back();
                                                  showCustomSnackBar(
                                                      value.message,
                                                      isError: false);
                                                }
                                              });
                                            }
                                          },
                                          buttonText: "update_key".tr,
                                          textColor:
                                              Theme.of(context).indicatorColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT,
                                  ),
                                ],
                              ),
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
