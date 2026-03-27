// ignore_for_file: constant_identifier_names, deprecated_member_use

import 'dart:io';
import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/data/model/body/popup_model.dart';
import 'package:invoicex/data/model/response/customer_list_model.dart';
import 'package:invoicex/data/repository/estimate_repo.dart';
import 'package:invoicex/helper/download_file.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/util/app_constants.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/api_checker.dart';
import '../data/model/response/estimate_model.dart';
import '../data/model/response/product_list_model.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/suggested_discount_type_model.dart';
import '../data/model/response/suggested_taxes_model.dart';
import '../helper/date_converter.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';
import 'invoice_controller.dart';
import 'package:http/http.dart' as http;

enum EstimateStatus { PENDING, APROVED, REJECT }

class EstimateController extends GetxController implements GetxService {
  final EstimateRepo estimateRepo;
  EstimateController({required this.estimateRepo});

  final createEstimateFormKey = GlobalKey<FormState>();

  final chooseCustomerController = TextEditingController();
  final chooseProductController = TextEditingController();
  final discountAmountController = TextEditingController();
  final dateController = TextEditingController();
  final templateController = TextEditingController();
  final filterController = TextEditingController();

  final chooseCustomerFocusNode = FocusNode();
  final chooseProductFocusNode = FocusNode();
  final discountAmountFocusNode = FocusNode();

  EstimateStatus? _estimateStatus;
  EstimateStatus? get estimateStatus => _estimateStatus;

  String? _dateRangeStartDate;
  String? get dateRangeStartDate => _dateRangeStartDate;

  String? _dateRangeEndDate;
  String? get dateRangeEndDate => _dateRangeEndDate;

  int? _selectedTemplate = 1;
  int? get selectedTemplate => _selectedTemplate;

  int? _customerListSelectedIndex;
  int? get customerListSelectedIndex => _customerListSelectedIndex;

  int _templateListCurrentIndex = 0;
  int get estimateTemplateListCurrentIndex => _templateListCurrentIndex;

  final int _estimateQuantity = 1;
  int get estimateQuantity => _estimateQuantity;

  String? _duePaymentReceivedDate;
  String? get duePaymentReceivedDate => _duePaymentReceivedDate;

  List<EstimateModel> _estimateList = [];
  List<EstimateModel> get estimateList => _estimateList;

  bool _estimateListLoading = false;
  bool get estimateListLoading => _estimateListLoading;

  bool _applyFilterLoading = false;
  bool get applyFilterLoading => _applyFilterLoading;

  bool _createEstimateSaveLoading = false;
  bool get createEstimateSaveLoading => _createEstimateSaveLoading;

  bool _createEstimateSendLoading = false;
  bool get createEstimateSendLoading => _createEstimateSendLoading;

  bool _getEstimateDetailsLoading = false;
  bool get getEstimateDetailsLoading => _getEstimateDetailsLoading;

  bool _updateEstimateSaveLoading = false;
  bool get updateEstimateSaveLoading => _updateEstimateSaveLoading;

  bool _updateEstimateSendLoading = false;
  bool get updateEstimateSendLoading => _updateEstimateSendLoading;

  bool _estimatePaginateLoading = false;
  bool get estimatePaginateLoading => _estimatePaginateLoading;

  String? _estimateNextPageUrl;
  String? get estimateNextPageUrl => _estimateNextPageUrl;

  int? _selectedEstimateIndex;
  int? get selectedEstimateIndex => _selectedEstimateIndex;

  List<SuggestedDiscountTypeModel> _suggestedDiscountTypeList = [];
  List<SuggestedDiscountTypeModel> get suggestedDiscountTypeList =>
      _suggestedDiscountTypeList;

  List<Map<String, String>> _suggestedDiscountTypeTitleList = [];
  List<Map<String, String>> get suggestedDiscountTypeTitleList =>
      _suggestedDiscountTypeTitleList;

  String? _suggestedDiscountTypeDWValue;
  String? get suggestedDiscountTypeDWValue => _suggestedDiscountTypeDWValue;

  List<SuggestedTaxesModel> _suggestedTaxesList = [];
  List<SuggestedTaxesModel> get suggestedTaxesList => _suggestedTaxesList;

  List<Map<String, String>> _suggestedTaxesTitleList = [];
  List<Map<String, String>> get suggestedTaxesTitleList =>
      _suggestedTaxesTitleList;

  List<CustomerListModel> _customerDropdownList = [];
  List<CustomerListModel> get customerDropdownList => _customerDropdownList;

  List<Map<String, String>> _customerDropdownStringList = [];
  List<Map<String, String>> get customerDropdownStringList =>
      _customerDropdownStringList;

  String? _customerDropdownValue;
  String? get customerDropdownValue => _customerDropdownValue;

  String? _customerFilterDropdownValue;
  String? get customerFilterDropdownValue => _customerFilterDropdownValue;

  String? _selectedCustomerIdValue;
  String? get selectedCustomerIdValue => _selectedCustomerIdValue;

  int? _selectedCustomerIndex;
  int? get selectedCustomerIndex => _selectedCustomerIndex;

  List<ProductListModel> _productDropdownList = [];
  List<ProductListModel> get productDropdownList => _productDropdownList;

  List<Map<String, String>> _productDropdownStringList = [];
  List<Map<String, String>> get productDropdownStringList =>
      _productDropdownStringList;

  String? _productDropdownValue;
  String? get productDropdownValue => _productDropdownValue;

  int? _selectedProductIndex;
  int? get selectedProductIndex => _selectedProductIndex;

  String? _suggestedTaxesDWValue;
  String? get suggestedTaxesDWValue => _suggestedTaxesDWValue;

  bool _suggestedAllItemListLoading = false;
  bool get suggestedAllItemListLoading => _suggestedAllItemListLoading;

  List<SelectedProductItemModel> _selectedProductItemList = [];
  List<SelectedProductItemModel> get selectedProductItemList =>
      _selectedProductItemList;

  List<int> _getDBEstimateIdList = [];

  List<int> _getDBTaxesIdList = [];

  List<SelectedTaxItemModel> _selectedTaxItemList = [];
  List<SelectedTaxItemModel> get selectedTaxItemList => _selectedTaxItemList;

  String? _noteTxt;
  String? get noteTxt => _noteTxt;

  double? _subTotal = 0.0;
  double? get subTotal => _subTotal;

  double? _discount = 0.0;
  double? get discount => _discount;

  double? _discountAmount = 0.0;
  double? get discountAmount => _discountAmount;

  double? _grandTotal = 0.0;
  double? get grandTotal => _grandTotal;

  String? _filterStartDate;
  String? get filterStartDate => _filterStartDate;

  String? _filterStartDateValue;
  String? get filterStartDateValue => _filterStartDateValue;

  String? _filterEndDate;
  String? get filterEndDate => _filterEndDate;

  String? _filterEndDateValue;
  String? get filterEndDateValue => _filterEndDateValue;

  bool _isEstimateFilter = false;
  bool get isEstimateFilter => _isEstimateFilter;

  String? _customerStatusDWValue;
  String? get customerStatusDWValue => _customerStatusDWValue;

  final List<Map<String, String>> _customerStatusList = [
    {
      'id': '6',
      'value': 'Pending',
    },
    {
      'id': '7',
      'value': 'Approved',
    },
    {
      'id': '8',
      'value': 'Reject',
    },
  ];
  List<Map<String, String>> get customerStatusList => _customerStatusList;

  String? _customerStatusId;
  String? get customerStatusId => _customerStatusId;

  Map<String, dynamic>? _selectedFilterCustomerItem;
  Map<String, dynamic>? get selectedFilterCustomerItem =>
      _selectedFilterCustomerItem;

  setSelectedFilterCustomerItem(Map<String, dynamic> map) {
    _selectedFilterCustomerItem = map;
    update();
  }

  //  Template image list
  List<String> templateEstimateImageList = [
    Images.estimateTemplate1,
    Images.estimateTemplate2,
    Images.estimateTemplate3,
  ];

  String _selectedPymentMethod = '';
  String get selectedPaymentMethod => _selectedPymentMethod;

  // payment method list
  final List<String> _paymentMethodList = [
    "",
    "cash_key",
    "bank_key",
    "bank_check_key",
    "crypto_key"
  ];
  List<String> get paymentMethodList => _paymentMethodList;

  // Estimate More item list pending
  List<PopupModel> _estimateMoreListPending = [];
  List<PopupModel> get estimateMoreListPending => _estimateMoreListPending;
  createEstimateMoreListPending() {
    _estimateMoreListPending = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateEstimates!)
        PopupModel(
            image: Images.edit,
            title: 'edit_key',
            route: RouteHelper.getAddEstimateRoute('2')),
      PopupModel(
          image: Images.viewDetails,
          title: 'view_details_key',
          route: RouteHelper.getEstimateDetailsRoute()),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.resendMailEstimate!)
        PopupModel(
          image: Images.resend,
          title: 'resend_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.resendAlert,
            title: 'are_you_sure_key'.tr,
            description: 'estimate_re_send_to_customer_mail_key'.tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              Get.find<EstimateController>().estimateSendAttachment();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .statusChangeEstimate!)
        PopupModel(
          image: Images.approved,
          title: 'Approved',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.resendAlert,
            title: 'are_you_sure_key'.tr,
            description: 'are_you_sure_want_to_approve_estimate'.tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              Get.find<EstimateController>()
                  .estimateStatusUpdate(status: 'status_approved');
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .statusChangeEstimate!)
        PopupModel(
          image: Images.approved,
          title: 'Reject'.tr,
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.resendAlert,
            title: 'are_you_sure_key'.tr,
            description: 'are_you_sure_want_to_reject_estimate'.tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              Get.find<EstimateController>()
                  .estimateStatusUpdate(status: 'status_reject');
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .invoiceConvertEstimate!)
        PopupModel(
          image: Images.convertToInvoice,
          title: 'convert_to_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.estimateToInvoiceAlert,
            title: 'are_you_sure_key'.tr,
            description: 'estimate_to_invoice_convert_key'.tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              Get.find<EstimateController>().estimateInvoiceConvert();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.downloadEstimate!)
        PopupModel(
          image: Images.downloadEstimate,
          title: 'download_estimate_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            imageHeight: 65,
            svgImagePath: Images.downloadAlert,
            title: "are_you_sure_key",
            description: 'are_you_sure_want_to_download_estimate'.tr,
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<EstimateController>().downloadPDF();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .downloadThermalEstimate!)
        PopupModel(
          image: Images.printingIcon,
          title: 'thermal_quotation_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            imageHeight: 65,
            svgImagePath: Images.downloadAlert,
            title: "are_you_sure_key",
            description: 'you_want_to_download_this_thermal_quotation'.tr,
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<EstimateController>().downloadThermalInvoicePDF();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteEstimates!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteAlert,
            title: 'are_you_sure_yoy_want_to_delete_key'.tr,
            description: 'this_content_will_be_deleted_permanently_key'.tr,
            leftBtnTitle: 'cancel_key'.tr,
            rightBtnTitle: 'delete_key'.tr,
            rightBtnOnTap: () {
              Get.find<EstimateController>().deleteEstimate();
            },
          ),
        ),
    ];
  }

  // Estimate More item list
  List<PopupModel> _estimateMoreList = [];
  List<PopupModel> get estimateMoreList => _estimateMoreList;
  createEstimateMoreList() {
    _estimateMoreList = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateEstimates!)
        PopupModel(
            image: Images.edit,
            title: 'edit_key',
            route: RouteHelper.getAddEstimateRoute('2')),
      PopupModel(
          image: Images.viewDetails,
          title: 'view_details_key',
          route: RouteHelper.getEstimateDetailsRoute()),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.resendMailEstimate!)
        PopupModel(
          image: Images.resend,
          title: 'resend_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.resendAlert,
            title: 'are_you_sure_key'.tr,
            description: 'estimate_re_send_to_customer_mail_key'.tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              Get.find<EstimateController>().estimateSendAttachment();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .invoiceConvertEstimate!)
        PopupModel(
          image: Images.convertToInvoice,
          title: 'convert_to_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.estimateToInvoiceAlert,
            title: 'are_you_sure_key'.tr,
            description: 'estimate_to_invoice_convert_key'.tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              Get.find<EstimateController>().estimateInvoiceConvert();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.downloadEstimate!)
        PopupModel(
          image: Images.downloadEstimate,
          title: 'download_estimate_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            imageHeight: 65,
            svgImagePath: Images.downloadAlert,
            title: "are_you_sure_key",
            description: 'are_you_sure_want_to_download_estimate'.tr,
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<EstimateController>().downloadPDF();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .downloadThermalEstimate!)
        PopupModel(
          image: Images.printingIcon,
          title: 'thermal_quotation_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            imageHeight: 65,
            svgImagePath: Images.downloadAlert,
            title: "are_you_sure_key",
            description: 'you_want_to_download_this_thermal_quotation'.tr,
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<EstimateController>().downloadThermalInvoicePDF();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteEstimates!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteAlert,
            title: 'are_you_sure_yoy_want_to_delete_key'.tr,
            description: 'this_content_will_be_deleted_permanently_key'.tr,
            leftBtnTitle: 'cancel_key'.tr,
            rightBtnTitle: 'delete_key'.tr,
            rightBtnOnTap: () {
              Get.find<EstimateController>().deleteEstimate();
            },
          ),
        ),
    ];
  }

  //  Set template list current index
  setTemplateListCurrentIndex(int value) {
    _templateListCurrentIndex = value;
    update();
  }

  //  Set customer list selected index
  setCustomerListSelectedIndex(int index) {
    _customerListSelectedIndex = index;
    update();
  }

  //  Set estimate status
  setEstimateStatus(EstimateStatus value) {
    _estimateStatus = value;
    update();
  }

  // Set selected template
  setSelectedTemplate(int value) {
    _selectedTemplate = value + 1;
    if (_selectedTemplate == 1) {
      templateController.text = 'template_one_key'.tr;
    } else if (_selectedTemplate == 2) {
      templateController.text = 'template_two_key'.tr;
    } else if (_selectedTemplate == 3) {
      templateController.text = 'template_three_key'.tr;
    }
    update();
  }

  // Set discount
  setDiscount(double value) {
    _discount = value;
    discountAmountCalculation();
    grandTotalCalculation();
    update();
  }

  //  Date select
  Future<void> selectDate(BuildContext context, int contain) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final val = DateConverter.estimatedDate(picked);
      if (contain == 0) {
        _dateRangeStartDate = val;
      } else if (contain == 1) {
        _dateRangeEndDate = val;
      } else if (contain == 2) {
        dateController.text = val;
      } else if (contain == 3) {
        _duePaymentReceivedDate = val;
      }
      update();
    }
  }

  // Estimate Quantity increment
  estimateQuantityIncrement({required int index}) {
    int quantity = int.parse(_selectedProductItemList[index].quantity.text);
    double price = _selectedProductItemList[index].price;
    quantity++;
    double totalPrice = 0.0;
    totalPrice = quantity * price;
    _selectedProductItemList[index].quantity.text = quantity.toString();
    _selectedProductItemList[index].totalPrice =
        double.parse(totalPrice.toStringAsFixed(2));
    subTotalCalculation();
    discountAmountCalculation();
    totalTaxCalculation();
    grandTotalCalculation();
    update();
  }

  // Estimate Quantity decrement
  estimateQuantityDecrement({required int index}) {
    int quantity = int.parse(_selectedProductItemList[index].quantity.text);
    double price = _selectedProductItemList[index].price;
    if (quantity != 1) {
      quantity--;
      double totalPrice = 0.0;
      totalPrice = quantity * price;
      _selectedProductItemList[index].quantity.text = quantity.toString();
      _selectedProductItemList[index].totalPrice =
          double.parse(totalPrice.toStringAsFixed(2));
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
      update();
    }
  }

  // Quantity change calculation
  quantityChangeCalculation({required int index, required int? quantity}) {
    if (quantity == null) {
      _selectedProductItemList[index].totalPrice = double.parse(
          _selectedProductItemList[index].price.toStringAsFixed(2));
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
    } else if (quantity <= 0) {
      _selectedProductItemList[index].quantity.text = '1';
      _selectedProductItemList[index].totalPrice = double.parse(
          _selectedProductItemList[index].price.toStringAsFixed(2));
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
    } else {
      double price = _selectedProductItemList[index].price;
      double totalPrice = 0.0;
      totalPrice = (quantity * price);
      _selectedProductItemList[index].totalPrice =
          double.parse(totalPrice.toStringAsFixed(2));
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
    }
    update();
  }

  // Get estimate data
  Future<ResponseModel> getEstimate({
    bool isPaginate = false,
    bool fromFilter = false,
    bool isApplyFilter = false,
  }) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _estimatePaginateLoading = true;
    } else {
      _estimateList = [];
      _estimateNextPageUrl = null;
      _estimateListLoading = true;
      _isEstimateFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    update();
    ResponseModel responseModel;

    if (fromFilter) {
      _selectedCustomerIdValue = _customerFilterDropdownValue != null
          ? _customerFilterDropdownValue
          : null;
      _filterStartDateValue = _filterStartDate;
      _filterEndDateValue = filterEndDate;
    }
    final response = await estimateRepo.getEstimate(
      url: estimateNextPageUrl,
      fromFilter: _isEstimateFilter,
      customerId: _selectedCustomerIdValue != null
          ? _selectedCustomerIdValue.toString()
          : "",
      status: _customerStatusId ?? "",
      startDate:
          DateConverter.convertToDateTimeFormat(_filterStartDateValue ?? ""),
      endDate: DateConverter.convertToDateTimeFormat(_filterEndDateValue ?? ""),
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _estimateList.add(EstimateModel.fromJson(item));
      });
      _estimateNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    if (isApplyFilter) {
      _applyFilterLoading = false;
    }
    if (isPaginate) {
      _estimatePaginateLoading = false;
    } else {
      _estimateListLoading = false;
    }
    update();
    return responseModel;
  }

  // Add value selected product item list
  addSelectedProductItemList({
    required int productId,
    required String name,
    required double price,
    required String quantity,
    required double totalPrice,
  }) {
    bool isExist = false;
    for (var item in _selectedProductItemList) {
      if (item.productId == productId) {
        isExist = true;
        break;
      }
    }
    if (isExist) {
      showCustomSnackBar('this_product_is_already_added_key'.tr);
    } else {
      _selectedProductItemList.add(
        SelectedProductItemModel(
          productId: productId,
          name: name,
          price: price,
          quantity: TextEditingController(text: quantity),
          totalPrice: totalPrice,
        ),
      );
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
      update();
    }
  }

  removeSelectedProductItem(int index) {
    _selectedProductItemList.removeAt(index);
    subTotalCalculation();
    discountAmountCalculation();
    totalTaxCalculation();
    grandTotalCalculation();
    update();
  }

  // Sub total calculation
  subTotalCalculation() {
    _subTotal = 0.0;
    for (var data in _selectedProductItemList) {
      _subTotal = (_subTotal! + data.totalPrice);
    }
  }

  // Discount amount calculation
  discountAmountCalculation() {
    if (discountAmountController.text.isNotEmpty) {
      _discountAmount = 0.0;
      double value = double.parse(discountAmountController.text);
      if (suggestedDiscountTypeDWValue == 'percentage') {
        _discountAmount = ((_subTotal! / 100) * value);
      } else if (suggestedDiscountTypeDWValue == 'fixed') {
        _discountAmount = value;
      }
    } else {
      _discountAmount = 0.0;
    }
    update();
  }

  // Get suggested discount type data
  Future<void> getSuggestedDiscountType() async {
    _suggestedAllItemListLoading = true;
    _suggestedDiscountTypeList = [];
    _suggestedDiscountTypeTitleList = [];
    update();
    final response = await estimateRepo.getSuggestedDiscountType();
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result'].forEach((item) {
        _suggestedDiscountTypeList
            .add(SuggestedDiscountTypeModel.fromJson(item));
        _suggestedDiscountTypeTitleList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });
      _suggestedDiscountTypeTitleList.add({
        'id': '0',
        'value': 'Reset',
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _suggestedAllItemListLoading = false;
    update();
  }

  // Set dropdown value
  setDiscountTypeDWValue(String value) {
    if (value == "0") {
      _suggestedDiscountTypeDWValue = null;
      discountAmountController.text = '';
      _discountAmount = null;
      _discount = 0.0;
      subTotalCalculation();
    } else {
      _suggestedDiscountTypeDWValue = value;
    }
    discountAmountCalculation();
    grandTotalCalculation();
    update();
  }

  // Get suggested taxes data
  Future<void> getSuggestedTaxes() async {
    _suggestedAllItemListLoading = true;
    _suggestedTaxesList = [];
    _suggestedTaxesTitleList = [];
    update();
    final response = await estimateRepo.getSuggestedTaxes();
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result'].forEach((item) {
        _suggestedTaxesList.add(SuggestedTaxesModel.fromJson(item));
        _suggestedTaxesTitleList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _suggestedAllItemListLoading = false;
    update();
  }

  // Set dropdown value
  setTaxesDWValue(String value) {
    _suggestedTaxesDWValue = value;
    addSelectedTaxItemList(id: value);
    update();
  }

  // Add value selected tax item list
  addSelectedTaxItemList({required String id}) {
    for (var data in _suggestedTaxesList) {
      if (data.id.toString() == id) {
        for (var info in _selectedTaxItemList) {
          if (info.taxId == data.id) {
            showCustomSnackBar('already_added_this_taxes_key'.tr,
                isError: true);
            return;
          }
        }
        _selectedTaxItemList.add(
          SelectedTaxItemModel(
            name: data.name ?? '',
            rate: (data.rate is double)
                ? data.rate
                : double.parse(data.rate.toString()),
            taxId: data.id!,
            totalTax: _discountAmount != null
                ? (((_subTotal! - _discountAmount!) / 100) * data.rate)
                : ((_subTotal! / 100) * data.rate),
          ),
        );
        grandTotalCalculation();
        break;
      }
    }
    update();
  }

  removeSelectedTaxItem(int index) {
    _selectedTaxItemList.removeAt(index);
    subTotalCalculation();
    discountAmountCalculation();
    totalTaxCalculation();
    grandTotalCalculation();
    update();
  }

  // Total tax calculation
  totalTaxCalculation() {
    if (_subTotal != null) {
      for (var data in _selectedTaxItemList) {
        if (_discountAmount != null) {
          data.totalTax = (((_subTotal! - _discountAmount!) / 100) * data.rate);
        } else {
          data.totalTax = ((_subTotal! / 100) * data.rate);
        }
      }
      update();
    }
  }

  // Grand total calculation
  grandTotalCalculation() {
    if (_subTotal != null) {
      _grandTotal = 0.0;
      double totalTaxAmount = 0.0;
      for (var data in _selectedTaxItemList) {
        totalTaxAmount += data.totalTax;
      }
      if (_discountAmount != null) {
        _grandTotal = ((_subTotal! - _discountAmount!) + totalTaxAmount);
      } else {
        _grandTotal = (_subTotal! + totalTaxAmount);
      }
      update();
    }
  }

  // Set selected estimate index
  setSelectedEstimateIndex(int index) {
    _selectedEstimateIndex = index;
  }

  clearEstimateData() {
    _selectedProductItemList = [];
    _selectedTaxItemList = [];
    _getDBEstimateIdList = [];
    _getDBTaxesIdList = [];
    chooseCustomerController.text = '';
    chooseProductController.text = '';
    discountAmountController.text = '';
    dateController.text = '';
    _selectedTemplate = null;
    _customerDropdownValue = null;
    _suggestedDiscountTypeDWValue = null;
    _suggestedTaxesDWValue = null;
    _discount = 0.0;
    _discountAmount = 0.0;
    _subTotal = 0.0;
    _grandTotal = 0.0;
  }

  // Create estimate
  Future<void> createEstimate({required String submitType}) async {
    if (submitType == '') {
      _createEstimateSaveLoading = true;
    } else {
      _createEstimateSendLoading = true;
    }
    update();

    List myProduct = [];
    List myTaxes = [];
    for (var product in _selectedProductItemList) {
      myProduct.add({
        'name': product.name,
        'price': product.price,
        'product_id': product.productId,
        'quantity': product.quantity.text,
        'total_amount': product.totalPrice,
      });
    }
    for (var tax in _selectedTaxItemList) {
      myTaxes.add({
        'name': tax.name,
        'rate': tax.rate,
        'tax_id': tax.taxId,
      });
    }

    final estimateDate =
        DateConverter.convertToDateTimeFormat(dateController.text);

    final response = await estimateRepo.createEstimate(
      map: {
        'customer_id': customerDropdownValue.toString(),
        'date': estimateDate,
        'products': myProduct,
        'estimate_template': _selectedTemplate,
        'discount_type': _suggestedDiscountTypeDWValue == "fixed"
            ? "fixed"
            : _suggestedDiscountTypeDWValue == "percentage"
                ? "percentage"
                : "none",
        'discount_amount': _discountAmount,
        'sub_total': _subTotal,
        'submit_type': submitType,
        'taxes': myTaxes,
        'total_amount': (_subTotal! - _discountAmount!),
        'grand_total': _grandTotal,
        'note': "",
      },
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      Get.back();
      Get.toNamed(RouteHelper.estimateScreen);
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _createEstimateSaveLoading = false;
    _createEstimateSendLoading = false;
    update();
  }

  // Get estimate details data
  Future<void> getEstimateDetails() async {
    _getEstimateDetailsLoading = true;
    _selectedProductItemList = [];
    _selectedTaxItemList = [];
    _getDBEstimateIdList = [];
    _getDBTaxesIdList = [];
    update();
    final response = await estimateRepo.getEstimateDetails(
        id: _estimateList[_selectedEstimateIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      final data = response.body['result'];
      setCustomerDropdownValue(data['customer_id'].toString());
      setSelectedTemplate(data['estimate_template'] - 1);
      dateController.text =
          DateConverter.estimatedDate(DateTime.parse(data['date']));
      data['discount_type'] == 'none'
          ? _suggestedDiscountTypeDWValue == null
          : setDiscountTypeDWValue(
              data['discount_type'] == 'fixed' ? "fixed" : "percentage");
      _noteTxt = data['note'];
      if (data['estimate_details'].isNotEmpty) {
        for (var item in data['estimate_details']) {
          _getDBEstimateIdList.add(item['id']);
          _selectedProductItemList.add(
            SelectedProductItemModel(
              id: item['id'],
              productId: item['product_id'],
              name: item['product_name'],
              price: (item['price'] is int)
                  ? double.parse(item['price'].toString())
                  : item['price'],
              quantity:
                  TextEditingController(text: item['quantity'].toString()),
              totalPrice: (double.parse(item['price'].toString()) *
                  double.parse(item['quantity'].toString())),
            ),
          );
        }
      } else {
        _selectedProductItemList = [];
      }
      subTotalCalculation();
      discountAmountController.text = data['discount_type'] == 'fixed'
          ? data['discount_amount'].toString()
          : data['discount_amount'] != null
              ? ((data['discount_amount'] / _subTotal) * 100).toString()
              : '0.0';
      _discount = data['discount_type'] == 'fixed'
          ? (data['discount_amount'] is int)
              ? double.parse(data['discount_amount'].toString())
              : data['discount_amount'] ?? 0.0
          : double.parse(discountAmountController.text);
      discountAmountCalculation();
      if (data['taxes'].isNotEmpty) {
        for (var item in data['taxes']) {
          _getDBTaxesIdList.add(item['id']);
          _selectedTaxItemList.add(
            SelectedTaxItemModel(
                id: item['id'],
                taxId: int.parse(item['tax_id'].toString()),
                name: item['name'],
                rate: (item['rate'] is int)
                    ? double.parse(item['rate'].toString())
                    : item['rate'],
                totalTax: _discountAmount != null
                    ? (((_subTotal! - _discountAmount!) / 100) * item['rate'])
                    : ((_subTotal! / 100) * item['rate'])),
          );
        }
      } else {
        _selectedTaxItemList = [];
      }
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    _getEstimateDetailsLoading = false;
    update();
  }

  // Update estimate
  Future<void> updateEstimate({required String submitType}) async {
    if (submitType == '') {
      _updateEstimateSaveLoading = true;
    } else {
      _updateEstimateSendLoading = true;
    }
    update();
    List myProductList = [];
    List myTaxesList = [];
    List<int> myRemoveEstimateList = [];
    List<int> myRemoveTaxesList = [];
    for (var id in _getDBEstimateIdList) {
      bool isFound = false;
      for (var product in _selectedProductItemList) {
        if (id == product.id) {
          isFound = true;
          break;
        } else {
          isFound = false;
        }
      }
      if (isFound == false) {
        myRemoveEstimateList.add(id);
      }
    }
    for (var id in _getDBTaxesIdList) {
      bool isFound = false;
      for (var tax in _selectedTaxItemList) {
        if (id == tax.id) {
          isFound = true;
          break;
        } else {
          isFound = false;
        }
      }
      if (isFound == false) {
        myRemoveTaxesList.add(id);
      }
    }

    for (var product in _selectedProductItemList) {
      myProductList.add({
        'name': product.name,
        'price': product.price,
        'id': product.id,
        'product_id': product.productId,
        'quantity': product.quantity.text,
        'total_amount': product.totalPrice,
      });
    }

    for (var tax in _selectedTaxItemList) {
      myTaxesList.add({
        'name': tax.name,
        'rate': tax.rate,
        'tax_id': tax.taxId,
        'id': tax.id,
      });
    }
    final estimateDate =
        DateConverter.convertToDateTimeFormat(dateController.text);
    final response = await estimateRepo.updateEstimate(
      map: {
        'customer_id': _customerDropdownValue.toString(),
        'date': estimateDate,
        'products': myProductList,
        'estimate_template': _selectedTemplate,
        'discount_type': _suggestedDiscountTypeDWValue == "fixed"
            ? "fixed"
            : _suggestedDiscountTypeDWValue == "percentage"
                ? "percentage"
                : 'none',
        'discount_amount': _discountAmount,
        'sub_total': _subTotal,
        'submit_type': submitType,
        'taxes': myTaxesList,
        'total_amount': (_subTotal! - _discountAmount!),
        'grand_total': _grandTotal,
        'note': "",
        'remove_product': myRemoveEstimateList,
        'remove_tax': myRemoveTaxesList,
      },
      id: _estimateList[_selectedEstimateIndex!].id!,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.offNamed(RouteHelper.estimateScreen);
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getEstimate();
    } else {
      ApiChecker.checkApi(response);
    }
    _updateEstimateSaveLoading = false;
    _updateEstimateSendLoading = false;
    update();
  }

  // Estimate send attachment data
  Future<void> estimateSendAttachment() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await estimateRepo.estimateSendAttachment(
        id: _estimateList[_selectedEstimateIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Estimate status update data
  Future<void> estimateStatusUpdate({required String status}) async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await estimateRepo.estimateStatusUpdate(
      id: _estimateList[_selectedEstimateIndex!].id!,
      map: {
        "status": status,
      },
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getEstimate();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Estimate invoice convert data
  Future<void> estimateInvoiceConvert() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await estimateRepo.estimateInvoiceConvert(
        id: _estimateList[_selectedEstimateIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Delete estimate data
  Future<void> deleteEstimate() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await estimateRepo.deleteEstimate(
        id: _estimateList[_selectedEstimateIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getEstimate();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

// Download estimate data
  Future<void> downloadEstimate() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await estimateRepo.downloadEstimate(
        id: _estimateList[_selectedEstimateIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.find<ExpensesController>().setDialogLoading(false);
      update();
      Get.back();
      File? file = await DownloadFile.downloadFile(
        // Corrected method name
        url: "${AppConstants.DOMAIN_URL}${response.body['result']}",
      );
      if (file != null) {
        showCustomSnackBar('download_complete_key'.tr, isError: false);
      }
    } else {
      Get.find<ExpensesController>().setDialogLoading(false);
      update();
      Get.back();
      ApiChecker.checkApi(response);
    }
  }

// View ESTIMATE data
  String? localFilePath;
  bool isPdfLoading = false;
  dynamic pdfPathList;
  Future<void> viewFile() async {
    try {
      isPdfLoading = true;
      final url =
          '${AppConstants.BASE_URL}${AppConstants.VIEW_ESTIMATE_URI}${_estimateList[_selectedEstimateIndex!].id}';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN) ?? "";

      print("object url ${url}");
      if (token.isEmpty) {
        // Handle missing token
        throw Exception("Token is missing");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final pdfPath =
            '${dir.path}/estimate_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File(pdfPath);
        await file.writeAsBytes(response.bodyBytes);
        localFilePath = file.path;
        _selectedEstimateIndex = null;

        pdfPathList = pdfPath;
        update();
      } else {
        // Handle non-200 responses
        throw Exception('Error fetching PDF: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      isPdfLoading = false;
      update();
    }
  }

  Future<void> shareFilePdf() async {
    final result = await Share.shareXFiles([XFile(pdfPathList)],
        text: 'Here is a PDF file.');
    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing my PDF!');
    }
  }

  Future<void> downloadPDF() async {
    try {
      Get.find<ExpensesController>().setDialogLoading(true);
      update();
      final url =
          '${AppConstants.BASE_URL}${AppConstants.VIEW_ESTIMATE_URI}${_estimateList[_selectedEstimateIndex!].id}';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN) ?? "";
      print('object $url');
      if (token.isEmpty) {
        // Handle missing token
        throw Exception("Token is missing");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final pdfPath =
            '${dir.path}/${_estimateList[_selectedEstimateIndex!].invoiceFullNumber}.pdf';
        final file = File(pdfPath);
        await file.writeAsBytes(response.bodyBytes);
        localFilePath = file.path;
        _selectedEstimateIndex = null;

        final result = await OpenFilex.open(localFilePath!);

        if (result.type != ResultType.done) {
          showCustomSnackBar('Error opening PDF'.tr, isError: true);
        }

        Get.find<ExpensesController>().setDialogLoading(false);
        Get.back();
        update();
      } else {
        throw Exception('Error fetching PDF: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      Get.find<ExpensesController>().setDialogLoading(false);
      update();
    } finally {
      isPdfLoading = false;
      update();
    }
  }

  Future<void> downloadThermalInvoicePDF() async {
    try {
      Get.find<ExpensesController>().setDialogLoading(true);
      update();
      final url =
          '${AppConstants.BASE_URL}${AppConstants.THERMAL_ESTIMATE_DOWNLOAD_URI}${_estimateList[_selectedEstimateIndex!].id}';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN) ?? "";
      print('object $url');
      if (token.isEmpty) {
        // Handle missing token
        throw Exception("Token is missing");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final pdfPath =
            '${dir.path}/${_estimateList[_selectedEstimateIndex!].invoiceFullNumber}.pdf';
        final file = File(pdfPath);
        await file.writeAsBytes(response.bodyBytes);
        localFilePath = file.path;
        _selectedEstimateIndex = null;

        final result = await OpenFilex.open(localFilePath!);

        if (result.type != ResultType.done) {
          showCustomSnackBar('Error opening PDF'.tr, isError: true);
        }

        Get.find<ExpensesController>().setDialogLoading(false);
        Get.back();
        update();
      } else {
        throw Exception('Error fetching PDF: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      Get.find<ExpensesController>().setDialogLoading(false);
      update();
    } finally {
      isPdfLoading = false;
      update();
    }
  }

  void refreshFilterForm() {
    _customerFilterDropdownValue = null;
    _customerDropdownValue = null;
    _filterStartDate = null;
    _filterEndDate = null;
    _customerStatusId = null;
    _customerStatusDWValue = null;
    _selectedFilterCustomerItem = null;
    filterController.text = '';
    update();
  }

  bool isEmptyFilterForm() {
    if (_customerFilterDropdownValue == null &&
        _customerDropdownValue == null &&
        _filterStartDate == null &&
        _filterEndDate == null &&
        _customerStatusId == null &&
        _customerStatusDWValue == null &&
        _selectedFilterCustomerItem == null &&
        filterController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void setFilterStartDate(String? date) {
    _filterStartDate = date;
    update();
  }

  void setFilterEndDate(String? date) {
    _filterEndDate = date;
    if (filterStartDate != null && filterEndDate != null) {
      filterController.text = "${filterStartDate}  To  ${filterEndDate}";
    }
    update();
  }

  // Set customer status dw value
  setCustomerStatusDWValue(String? value) {
    _customerStatusDWValue = value;
    _customerStatusId = value;
    update();
  }

  // Get customer list
  Future<void> getCustomerListDropdown() async {
    _suggestedAllItemListLoading = true;
    _customerDropdownList = [];
    _customerDropdownStringList = [];
    update();
    final response = await estimateRepo.getCustomerListDropdown();
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']["data"].forEach((item) {
        _customerDropdownList.add(CustomerListModel.fromJson(item));
        _customerDropdownStringList.add({
          'id': item['id'].toString(),
          'value': item['full_name'],
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _suggestedAllItemListLoading = false;
    update();
  }

  setCustomerDropdownValue(String? value) {
    _customerDropdownValue = value;
    update();
  }

// Set Customer filter dw value
  setCustomerFilterDropdownValue(String? value) {
    _customerFilterDropdownValue = value;
    update();
  }
  // Product list Show in dropdown

  setProductDropdownValue(String value) async {
    _productDropdownValue = value;
    int index = await productIdToProductDropdownListIndexConvert(value);
    var info = _productDropdownList[index];
    addSelectedProductItemList(
      productId: info.id ?? 0,
      name: info.name ?? '',
      price: (info.price is int)
          ? double.parse(info.price.toString())
          : info.price,
      quantity: '1',
      totalPrice: (info.price is int)
          ? double.parse(info.price.toString())
          : info.price,
    );
    update();
  }

  // Product name to productDropdownList index converter
  int productIdToProductDropdownListIndexConvert(String id) {
    int? index;
    for (int i = 0; i < _productDropdownList.length; i++) {
      var element = _productDropdownList[i];
      if (element.id.toString() == id) {
        index = i;
        return index;
      }
    }
    return index!;
  }

  // Get product list
  Future<void> getProductListDropdown() async {
    _suggestedAllItemListLoading = true;
    _productDropdownList = [];
    _productDropdownStringList = [];
    _productDropdownValue = null;
    update();
    final response = await estimateRepo.getProductListDropdown();
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']["data"].forEach((item) {
        _productDropdownList.add(ProductListModel.fromJson(item));
        _productDropdownStringList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _suggestedAllItemListLoading = false;
    update();
  }
}
