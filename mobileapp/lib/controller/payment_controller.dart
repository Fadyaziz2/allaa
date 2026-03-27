import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/data/api/api_checker.dart';
import 'package:invoicex/data/model/body/add_payment_method_body.dart';
import 'package:invoicex/data/model/response/payment_methods_dropdown_model.dart';
import 'package:invoicex/data/model/response/payment_methods_model.dart';
import 'package:invoicex/data/repository/payment_methods_repo.dart';
import 'package:invoicex/view/base/custom_snackbar.dart';
import 'package:invoicex/view/screens/payment/widget/add_payment_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/payment_gateway_model.dart';
import '../data/model/response/payment_method_details_model.dart';
import '../data/model/response/payment_method_model.dart';
import '../data/model/response/response_model.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';

class PaymentController extends GetxController implements GetxService {
  final PaymentMethodsRepo paymentMethodsRepo;
  PaymentController({required this.paymentMethodsRepo});

  List<PaymentMethodsModel> _paymentMethodsList = [];
  List<PaymentMethodsModel> get paymentMethodsList => _paymentMethodsList;

  bool _paymentListLoading = false;
  bool get paymentListLoading => _paymentListLoading;

  int? _selectedPaymentIndex;
  int? get selectedPaymentIndex => _selectedPaymentIndex;

  bool _paymentPaginateLoading = false;
  bool get paymentPaginateLoading => _paymentPaginateLoading;

  String? _paymentNextPageUrl;
  String? get paymentNextPageUrl => _paymentNextPageUrl;

  List<PaymentMethodDropdownModel> _paymentDropdownList = [];
  List<PaymentMethodDropdownModel> get paymentDropdownList =>
      _paymentDropdownList;

  List<PaymentMethodModel> _paymentMethodDropdownList = [];
  List<PaymentMethodModel> get paymentMethodDropdownList =>
      _paymentMethodDropdownList;

  List<PaymentGatewayModel> _paymentGatewayDropdownList = [];
  List<PaymentGatewayModel> get paymentGatewayDropdownList =>
      _paymentGatewayDropdownList;

  PaymentGatewayModel? _paymentGatewayDropdownValue;
  PaymentGatewayModel? get paymentGatewayDropdownValue =>
      _paymentGatewayDropdownValue;

  bool _paymentDropdownLoading = false;
  bool get paymentDropdownLoading => _paymentDropdownLoading;

  List<Map<String, String>> _paymentDropdownStringList = [];
  List<Map<String, String>> get paymentDropdownStringList =>
      _paymentDropdownStringList;

  List<Map<String, String>> _paymentMethodDropdownStringList = [];
  List<Map<String, String>> get paymentMethodDropdownStringList =>
      _paymentMethodDropdownStringList;

  List<Map<String, String>> _paymentGatewayDropdownStringList = [];
  List<Map<String, String>> get paymentGatewayDropdownStringList =>
      _paymentGatewayDropdownStringList;

  final List<Map<String, String>> _paymentModeList = [
    {
      'id': 'Sandbox',
      'value': 'Sandbox',
    },
    {
      'id': 'Live',
      'value': 'Live',
    },
  ];
  List<Map<String, String>> get paymentModeList => _paymentModeList;

  String? _paymentDropdownValue;
  String? get paymentDropdownValue => _paymentDropdownValue;

  String? _paymentMethodDropdownValue;
  String? get paymentMethodDropdownValue => _paymentMethodDropdownValue;

  String? _paymentModeValue;
  String? get paymentModeValue => _paymentModeValue;

  bool _addPaymentMethodLoading = false;
  bool get addPaymentMethodLoading => _addPaymentMethodLoading;

  bool _updatePaymentMethodLoading = false;
  bool get updatePaymentMethodLoading => _updatePaymentMethodLoading;

  bool _isPaymentMethodDetailsLoading = false;
  bool get isPaymentMethodDetailsLoading => _isPaymentMethodDetailsLoading;

  PaymentMethodDetailsModel? _paymentMethodDetailsModel;
  PaymentMethodDetailsModel? get paymentMethodDetailsModel =>
      _paymentMethodDetailsModel;

  // Payment More item list
  List<PopupModel> _paymentMoreList = [];
  List<PopupModel> get paymentMoreList => _paymentMoreList;
  createPaymentMethodMoreList() {
    _paymentMoreList = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .updatePaymentMethods!)
        PopupModel(
            image: Images.edit,
            title: 'edit_key',
            route: '',
            widget: AddPaymentDialog(
              isUpdate: true,
            ),
            isRoute: false),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .deletePaymentMethods!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteDialogIcon,
            description: 'this_content_will_be_deleted_key',
            title: "you_want_to_delete_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<PaymentController>().deletePaymentMethods();
            },
          ),
        ),
    ];
  }

  // Get Payment Methods data
  Future<void> getPaymentMethods({bool isPaginate = false}) async {
    if (isPaginate) {
      _paymentPaginateLoading = true;
    } else {
      _paymentListLoading = true;
      _paymentMethodsList = [];
      _paymentNextPageUrl = null;
    }
    update();
    final response =
        await paymentMethodsRepo.getPaymentMethods(url: paymentNextPageUrl);
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _paymentMethodsList.add(PaymentMethodsModel.fromJson(item));
      });
      _paymentNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
    } else {
      _paymentListLoading = false;
      _paymentPaginateLoading = false;
      update();
      ApiChecker.checkApi(response);
    }
    if (isPaginate) {
      _paymentPaginateLoading = false;
    } else {
      _paymentListLoading = false;
    }
    update();
  }

  void refreshForm() {
    _paymentDropdownValue = null;
    _paymentModeValue = null;
    if (kDebugMode) {
      print("Dropdown value:  $_paymentModeValue");
    }
    update();
  }

  // Set category dw value
  setPaymentDropdownValue(String? value) {
    _paymentDropdownValue = value;
    update();
  }

  // Set payment mode dw value
  setPaymentModeValue(String? value) {
    _paymentModeValue = value;
    update();
  }

  // Get Payment Methods Dropdown data
  Future<void> getPaymentMethodsDropdown() async {
    _paymentDropdownLoading = true;
    _paymentDropdownList = [];
    _paymentDropdownStringList = [];
    _paymentDropdownValue = null;
    update();
    final response = await paymentMethodsRepo.getPaymentMethodsDropdown();
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result'].forEach((item) {
        _paymentDropdownList.add(PaymentMethodDropdownModel.fromJson(item));
        _paymentDropdownStringList.add({
          'id': item['name'],
          'value': item['name'],
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _paymentDropdownLoading = false;
    update();
  }

  // Get Payment Methods Dropdown list data
  Future<void> getPaymentMethodsDropdownList() async {
    _paymentDropdownLoading = true;
    _paymentMethodDropdownList = [];
    _paymentMethodDropdownStringList = [];
    _paymentMethodDropdownValue = null;
    update();
    final response = await paymentMethodsRepo.getPaymentMethodsDropdownList();
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result'].forEach((item) {
        _paymentMethodDropdownList.add(PaymentMethodModel.fromJson(item));
        _paymentMethodDropdownStringList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _paymentDropdownLoading = false;
    update();
  }

  Future<void> getPaymentGateWayDropdownList() async {
    _paymentDropdownLoading = true;
    _paymentGatewayDropdownList = [];
    _paymentGatewayDropdownStringList = [];
    _paymentGatewayDropdownValue = null;
    update();
    final response = await paymentMethodsRepo.getPaymentGatewayDropdownList();
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result'].forEach((item) {
        _paymentGatewayDropdownList.add(PaymentGatewayModel.fromJson(item));
        _paymentGatewayDropdownStringList.add({
          'id': item['id'].toString(),
          'value': item['name'],
          'type': item['type'],
          'api_key': item['api_key'],
          'api_secret': item['api_secret'],
          'payment_mode': item['payment_mode']??"",
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _paymentDropdownLoading = false;
    update();
  }

  setSelectedPaymentIndex(int index) {
    _selectedPaymentIndex = index;
  }

  // Delete Payment Methods data
  Future<void> deletePaymentMethods() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await paymentMethodsRepo.deletePaymentMethods(
        id: _paymentMethodsList[_selectedPaymentIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getPaymentMethods();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Add Payment Method
  Future<ResponseModel> addPaymentMethod(
      {required AddPaymentMethodBody addPaymentMethodBody}) async {
    _addPaymentMethodLoading = true;
    update();
    Response response = await paymentMethodsRepo.addPaymentMethod(
        addPaymentMethodBody: addPaymentMethodBody);
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      getPaymentMethods();
      responseModel = ResponseModel(
        true,
        response.body['message'],
      );
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _addPaymentMethodLoading = false;
    update();
    return responseModel;
  }

  // get Payment Method Details
  Future<void> getPaymentMethodDetails() async {
    _isPaymentMethodDetailsLoading = true;
    _paymentMethodDetailsModel = null;
    update();

    Response response = await paymentMethodsRepo.getPaymentMethodDetails(
        id: _paymentMethodsList[_selectedPaymentIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      _paymentMethodDetailsModel =
          PaymentMethodDetailsModel.fromJson(response.body["result"]);
      _paymentDropdownValue = _paymentMethodDetailsModel!.type!.capitalizeFirst;
    } else {
      ApiChecker.checkApi(response);
    }
    _isPaymentMethodDetailsLoading = false;
    update();
  }

  // Update Payment Method
  Future<ResponseModel> updatePaymentMethod(
      {required AddPaymentMethodBody addPaymentMethodBody}) async {
    _updatePaymentMethodLoading = true;
    update();
    Response response = await paymentMethodsRepo.updatePaymentMethod(
        addPaymentMethodBody: addPaymentMethodBody,
        id: _paymentMethodsList[_selectedPaymentIndex!].id!);
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      getPaymentMethods();
      responseModel = ResponseModel(
        true,
        response.body['message'],
      );
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _updatePaymentMethodLoading = false;
    update();
    return responseModel;
  }

  String? getPaymentMethodId(String value) {
    String? id;
    for (var element in _paymentDropdownList) {
      if (element.name == value) {
        id = element.id!;
      }
    }
    return id;
  }

  dynamic getPaymentMethodIdFromList(String value) {
    String? id;
    for (var element in _paymentMethodDropdownList) {
      if (element.name == value) {
        id = element.id.toString();
      }
    }
    return id;
  }
}
