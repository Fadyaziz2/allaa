// ignore_for_file: constant_identifier_names

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/controller/dashboard_controller.dart';
import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/data/model/body/add_customer_body.dart';
import 'package:invoicex/data/model/response/customer_details_model.dart';
import 'package:invoicex/data/model/response/customer_invoice_detile_model.dart';
import 'package:invoicex/data/model/response/customer_model.dart';
import 'package:invoicex/data/model/response/customer_update_details_model.dart';
import 'package:invoicex/data/repository/customer_repo.dart';

import '../data/api/api_checker.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/response_model.dart';
import '../helper/route_helper.dart';
import '../util/dimensions.dart';
import '../util/images.dart';
import '../util/styles.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';

enum CustomerStatus { ACTIVE, INACTIVE }

class CustomerController extends GetxController implements GetxService {
  CustomerRepo customerRepo;
  CustomerController({required this.customerRepo});

  bool _allowPortalAccess = false;
  bool get allowPortalAccess => _allowPortalAccess;

  bool _isCustomerLoading = false;
  bool get isCustomerLoading => _isCustomerLoading;

  bool _isCustomerUpdateLoading = false;
  bool get isCustomerUpdateLoading => _isCustomerUpdateLoading;

  bool _isCustomerInvoiceLoading = false;
  bool get isCustomerInvoiceLoading => _isCustomerInvoiceLoading;

  bool _isCustomerDetailsLoading = false;
  bool get isCustomerDetailsLoading => _isCustomerDetailsLoading;

  bool _isCustomerUpdateDetailsLoading = false;
  bool get isCustomerUpdateDetailsLoading => _isCustomerUpdateDetailsLoading;

  bool _isPaginateLoading = false;
  bool get isPaginateLoading => _isPaginateLoading;

  bool _isInvoicePaginateLoading = false;
  bool get isInvoicePaginateLoading => _isInvoicePaginateLoading;

  String? _customerNextPageUrl;
  String? get customerNextPageUrl => _customerNextPageUrl;

  String? _customerInvoiceNextPageUrl;
  String? get customerInvoiceNextPageUrl => _customerInvoiceNextPageUrl;

  List<CustomerModel> _customerList = [];
  List<CustomerModel> get customerList => _customerList;

  List<CustomerInvoiceDetilesModel> _customerInvoiceList = [];
  List<CustomerInvoiceDetilesModel> get customerInvoiceList =>
      _customerInvoiceList;

  String _countryCodeNumber = '+20';
  String get countryCodeNumber => _countryCodeNumber;

  CustomerDetailsModel? _customerDetailsModel;
  CustomerDetailsModel? get customerDetailsModel => _customerDetailsModel;

  CustomerUpdateDetailsModel? _customerUpdateDetailsModel;
  CustomerUpdateDetailsModel? get customerUpdateDetailsModel =>
      _customerUpdateDetailsModel;

  static int _customerSelectedId = -1;
  static int get customerSelectedId => _customerSelectedId;

  static String _customerSelectedStatus = "status_active";
  static String get customerSelectedStatus => _customerSelectedStatus;

  CustomerStatus? _customerStatus;
  CustomerStatus? get customerStatus => _customerStatus;

  String? _customerStatusDWValue;
  String? get customerStatusDWValue => _customerStatusDWValue;

  final List<Map<String, String>> _customerStatusList = [
    {
      'id': '1',
      'value': 'Active',
    },
    {
      'id': '2',
      'value': 'Inactive',
    },
    {
      'id': '3',
      'value': 'Invited',
    },
  ];
  List<Map<String, String>> get customerStatusList => _customerStatusList;

  bool _isCustomerFilter = false;
  bool get isCustomerFilter => _isCustomerFilter;

  bool _customerFilter = false;
  bool get customerFilter => _customerFilter;

  // customer country code
  Country _customerCountry = CountryParser.parseCountryCode("EG");
  Country get customerCountry => _customerCountry;

  void toggleAllowPortalAccess() {
    _allowPortalAccess = !_allowPortalAccess;
    update();
  }

  // Set update portal access value
  void setUpdatePortalAccess(bool value) {
    _allowPortalAccess = value;
    update();
  }

  // Customer More item list
  List<PopupModel> _customerMoreList = [];
  List<PopupModel> get customerMoreList => _customerMoreList;
  createCustomerMoreList() {
    _customerMoreList = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateCustomers!)
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: RouteHelper.getAddCustomerRoute('1'),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .detailsViewCustomer!)
        PopupModel(
          image: Images.viewDetails,
          title: 'view_details_key',
          route: RouteHelper.getCustomerDetailsRoute(),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .customerResendPortalAccess!)
        PopupModel(
          image: Images.sendPortal,
          title: 'send_portal_access_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.estimateToInvoiceAlert,
            description: 'send_customer_portal_key'.tr,
            leftBtnTitle: 'cancel_key'.tr,
            rightBtnTitle: 'send_key'.tr,
            rightBtnOnTap: () {
              Get.find<CustomerController>().customerResendPortalAccess();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateCustomers!)
        PopupModel(
          image: Images.inactiveUser,
          title: _customerSelectedStatus == "status_active"
              ? 'active_key'
              : "inactive_key",
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.estimateToInvoiceAlert,
            description:
                'are_you_sure_you_want_to_change_customer_status_key'.tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              Get.find<CustomerController>().customerUpdateStatus();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteCustomers!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteAlert,
            title: 'are_you_sure_yoy_want_to_delete_key'.tr,
            description: 'this_content_will_be_deleted_permanently_key'.tr,
            leftBtnTitle: 'cancel_key',
            rightBtnTitle: 'delete_key',
            rightBtnOnTap: () {
              Get.find<CustomerController>().deleteCustomer();
            },
          ),
        ),
    ];
  }

  // Get Customer data
  Future<ResponseModel> getCustomerData(
      {bool isPaginate = false, bool fromFilter = false}) async {
    if (isPaginate) {
      _isPaginateLoading = true;
    } else {
      _customerList = [];
      _customerNextPageUrl = null;
      _isCustomerLoading = true;
      _isCustomerFilter = fromFilter;
      if (!fromFilter) {
        _customerStatusDWValue = null;
      } else {
        _customerFilter = true;
      }
    }
    update();

    ResponseModel responseModel;

    final response = await customerRepo.getCustomerData(
        url: customerNextPageUrl,
        fromFilter: _isCustomerFilter,
        status: _customerStatusDWValue != null ? _customerStatusDWValue : '');
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _customerList.add(CustomerModel.fromJson(item));
      });

      _customerNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }
    if (isPaginate) {
      _isPaginateLoading = false;
    } else {
      _isCustomerLoading = false;
      _customerFilter = false;
    }
    update();
    return responseModel;
  }

  // Add Customer
  Future<ResponseModel> addCustomer(
      {required AddCustomerBody addCustomerBody}) async {
    _isCustomerLoading = true;
    update();
    Response response =
        await customerRepo.addCustomer(addCustomerBody: addCustomerBody);
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      responseModel = ResponseModel(
        true,
        response.body['message'],
      );
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _isCustomerLoading = false;
    update();
    return responseModel;
  }

  // Set customer country code
  void setCountryCode(String code) {
    _customerCountry = CountryParser.parseCountryCode(code);
    update();
  }

  // refresh data
  void refreshData() {
    _countryCodeNumber = '+20';
    _allowPortalAccess = false;
    update();
  }

  // Get customer details method
  Future<void> getCustomerDetails() async {
    _isCustomerDetailsLoading = true;
    update();
    Response response = await customerRepo.getCustomerDetails(
        id: _customerSelectedId.toString());
    if (response.statusCode == 200 && response.body['status'] == true) {
      _customerDetailsModel = null;
      _customerDetailsModel =
          CustomerDetailsModel.fromJson(response.body['result']);
    } else {
      ApiChecker.checkApi(response);
    }
    _isCustomerDetailsLoading = false;
    update();
  }

  // Set customer on tap id
  void setCustomerSelectedId({required int id, required String status}) {
    _customerSelectedId = id;
    _customerSelectedStatus = status;

    if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
        Get.find<PermissionController>().permissionModel!.updateCustomers!) {
      for (int i = 0; i < _customerMoreList.length; i++) {
        if (_customerMoreList[i].image == Images.inactiveUser) {
          _customerMoreList[i] = PopupModel(
            image: Images.inactiveUser,
            title: _customerSelectedStatus == "status_active"
                ? 'active_key'
                : "inactive_key",
            route: '',
            isRoute: false,
            widget: ConfirmationDialog(
              svgImagePath: Images.estimateToInvoiceAlert,
              description:
                  'are_you_sure_you_want_to_change_customer_status_key'.tr,
              leftBtnTitle: 'no_key'.tr,
              rightBtnTitle: 'yes_key'.tr,
              rightBtnOnTap: () {
                customerUpdateStatus();
              },
            ),
          );
        }
      }
    }
    update();
  }

  // Get Customer Details
  Future<void> getCustomerInvoiceDetails({bool isPaginate = false}) async {
    if (isPaginate) {
      _isInvoicePaginateLoading = true;
    } else {
      _customerInvoiceList = [];
      _customerInvoiceNextPageUrl = null;
      _isCustomerInvoiceLoading = true;
    }
    update();
    final response = await customerRepo.getCustomerInvoiceDetails(
        url: customerInvoiceNextPageUrl, id: _customerSelectedId.toString());
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _customerInvoiceList.add(CustomerInvoiceDetilesModel.fromJson(item));
      });

      _customerInvoiceNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
    } else {
      ApiChecker.checkApi(response);
    }
    if (isPaginate) {
      _isInvoicePaginateLoading = false;
    } else {
      _isCustomerInvoiceLoading = false;
    }
    update();
  }

  // Delete Customer
  Future<void> deleteCustomer() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await customerRepo.deleteCustomer(id: _customerSelectedId);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getCustomerData();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Customer resend portal access method
  Future<void> customerResendPortalAccess() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    Response response = await customerRepo.customerResendPortalAccess(
        id: _customerSelectedId.toString());
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Customer Update Status
  Future<void> customerUpdateStatus() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    Response response = await customerRepo.customerUpdateStatus(
        id: _customerSelectedId.toString(), status: _customerSelectedStatus);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.isSnackbarOpen ? Get.back() : null;
      Get.back();

      getCustomerData();

      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Get customer update details method
  Future<void> getCustomerUpdateDetails() async {
    _isCustomerUpdateDetailsLoading = true;
    update();
    Response response = await customerRepo.getCustomerUpdateDetails(
        id: _customerSelectedId.toString());
    if (response.statusCode == 200 && response.body['status'] == true) {
      _customerUpdateDetailsModel = null;
      _customerUpdateDetailsModel =
          CustomerUpdateDetailsModel.fromJson(response.body['result']);
    } else {
      ApiChecker.checkApi(response);
    }
    _isCustomerUpdateDetailsLoading = false;
    update();
  }

  // Update Customer
  Future<ResponseModel> customerUpdate(
      {required AddCustomerBody addCustomerBody}) async {
    _isCustomerUpdateLoading = true;
    update();
    Response response = await customerRepo.customerUpdate(
        id: _customerSelectedId.toString(), addCustomerBody: addCustomerBody);
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      responseModel = ResponseModel(
        true,
        response.body['message'],
      );
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _isCustomerUpdateLoading = false;
    update();
    return responseModel;
  }

  //  Set customer status
  setCustomerStatus(CustomerStatus value) {
    _customerStatus = value;
    update();
  }

  // Set customer status dw value
  setCustomerStatusDWValue(String? value) {
    _customerStatusDWValue = value;

    update();
  }

  void refreshFilterForm() {
    _customerStatusDWValue = null;
    update();
  }

  // Show country bottom sheet
  void showPicker(BuildContext context, {bool fromProfile = false}) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        searchTextStyle: poppinsMedium.copyWith(
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
        ),
        bottomSheetHeight: Get.size.height * 0.80,
        backgroundColor: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        inputDecoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
          hintText: 'search_your_country_here_key'.tr,
          hintStyle: poppinsRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).disabledColor),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error.withAlpha(7),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error.withAlpha(7),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide(
              color: Theme.of(context).disabledColor.withAlpha(3),
              width: 1,
            ),
          ),
        ),
      ),
      onSelect: (country) {
        if (fromProfile) {
          Get.find<DashboardController>().setCountry(country);
        } else {
          _customerCountry = country;
          update();
        }
      },
    );
  }

  // Remove country code from customer phone number
  String removeCountryCode(String phoneNumber) {
    return phoneNumber.replaceAll("+${_customerCountry.phoneCode}", '');
  }
}
