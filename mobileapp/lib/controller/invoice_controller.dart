// ignore_for_file: constant_identifier_names, deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/controller/transaction_controller.dart';
import 'package:invoicex/data/model/body/due_payment_body.dart';
import 'package:invoicex/data/model/body/popup_model.dart';
import 'package:invoicex/data/model/response/invoice_model.dart';
import 'package:invoicex/data/repository/invoice_repo.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/view/screens/invoice/widget/due_payment_dialog.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/customer_list_model.dart';
import '../data/model/response/product_list_model.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/suggested_discount_type_model.dart';
import '../data/model/response/suggested_taxes_model.dart';
import '../helper/date_converter.dart';
import '../helper/download_file.dart';
import '../util/app_constants.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';
import '../view/screens/invoice/widget/payment_dialog.dart';
import 'dashboard_controller.dart';

enum InvoiceStatus { PAID, DUE }

class InvoiceController extends GetxController implements GetxService {
  final InvoiceRepo invoiceRepo;

  InvoiceController({required this.invoiceRepo});

  final createInvoiceFormKey = GlobalKey<FormState>();

  final chooseCustomerController = TextEditingController();
  final chooseProductController = TextEditingController();
  final refNumberController = TextEditingController();
  final discountAmountController = TextEditingController();
  final receivedAmountController = TextEditingController();
  final issueDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final duePaymentDateController = TextEditingController();
  final templateController = TextEditingController();
  final issueFilterController = TextEditingController();
  final dueFilterController = TextEditingController();

  final chooseCustomerFocusNode = FocusNode();
  final chooseProductFocusNode = FocusNode();
  final refNumberFocusNode = FocusNode();
  final discountAmountFocusNode = FocusNode();
  final receivedAmountFocusNode = FocusNode();

  InvoiceStatus? _invoiceStatus;

  InvoiceStatus? get invoiceStatus => _invoiceStatus;

  String? _dateRangeStartDate;

  String? get dateRangeStartDate => _dateRangeStartDate;

  String? _dateRangeEndDate;

  String? get dateRangeEndDate => _dateRangeEndDate;

  int? _selectedTemplate;

  int? get selectedTemplate => _selectedTemplate;

  int? _customerListSelectedIndex;

  int? get customerListSelectedIndex => _customerListSelectedIndex;

  int _invoiceTemplateListCurrentIndex = 0;

  int get invoiceTemplateListCurrentIndex => _invoiceTemplateListCurrentIndex;

  final int _invoiceQuantity = 1;

  int get invoiceQuantity => _invoiceQuantity;

  List<InvoiceModel> _invoiceList = [];

  List<InvoiceModel> get invoiceList => _invoiceList;

  bool _invoiceListLoading = false;

  bool get invoiceListLoading => _invoiceListLoading;

  bool _applyFilterLoading = false;

  bool get applyFilterLoading => _applyFilterLoading;

  bool _createInvoiceSaveLoading = false;

  bool get createInvoiceSaveLoading => _createInvoiceSaveLoading;

  bool _createInvoiceSendLoading = false;

  bool get createInvoiceSendLoading => _createInvoiceSendLoading;

  bool _getInvoiceDetailsLoading = false;

  bool get getInvoiceDetailsLoading => _getInvoiceDetailsLoading;

  bool _updateInvoiceSaveLoading = false;

  bool get updateInvoiceSaveLoading => _updateInvoiceSaveLoading;

  bool _updateInvoiceSendLoading = false;

  bool get updateInvoiceSendLoading => _updateInvoiceSendLoading;

  bool _invoicePaginateLoading = false;

  bool get invoicePaginateLoading => _invoicePaginateLoading;

  String? _invoiceNextPageUrl;

  String? get invoiceNextPageUrl => _invoiceNextPageUrl;

  int? _selectedInvoiceIndex;

  int? get selectedInvoiceIndex => _selectedInvoiceIndex;

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

  String? _suggestedTaxesDWValue;

  String? get suggestedTaxesDWValue => _suggestedTaxesDWValue;

  bool _suggestedAllItemListLoading = false;

  bool get suggestedAllItemListLoading => _suggestedAllItemListLoading;

  bool _duePaymentLoading = false;
  bool get duePaymentLoading => _duePaymentLoading;

  List<int> _getDBInvoiceIdList = [];

  List<int> _getDBTaxesIdList = [];

  List<SelectedProductItemModel> _selectedProductItemList = [];

  List<SelectedProductItemModel> get selectedProductItemList =>
      _selectedProductItemList;

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

  double? _dueAmount = 0.0;

  double? get dueAmount => _dueAmount;

  String? _filterIssueStartDate;

  String? get filterIssueStartDate => _filterIssueStartDate;

  String? _filterIssueStartDateValue;

  String? get filterIssueStartDateValue => _filterIssueStartDateValue;

  String? _filterIssueEndDate;

  String? get filterIssueEndDate => _filterIssueEndDate;

  String? _filterIssueEndDateValue;

  String? get filterIssueEndDateValue => _filterIssueEndDateValue;

  String? _filterDueStartDate;

  String? get filterDueStartDate => _filterDueStartDate;

  String? _filterDueStartDateValue;

  String? get filterDueStartDateValue => _filterDueStartDateValue;

  String? _filterDueEndDate;

  String? get filterDueEndDate => _filterDueEndDate;

  String? _filterDueEndDateValue;

  String? get filterDueEndDateValue => _filterDueEndDateValue;

  bool _isInvoiceFilter = false;

  bool get isInvoiceFilter => _isInvoiceFilter;

  String? _customerStatusDWValue;

  String? get customerStatusDWValue => _customerStatusDWValue;

  final List<Map<String, String>> _customerStatusList = [
    {
      'id': '4',
      'value': 'Paid',
    },
    {
      'id': '5',
      'value': 'Due',
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

  List<String> templateInvoiceImageList = [
    Images.invoiceTemplate4,
    Images.invoiceTemplate5,
    Images.invoiceTemplate6,
  ];

  String? _paymentMethodDWValue;

  String? get paymentMethodDWValue => _paymentMethodDWValue;

  String? _paymentGatewayDWValue;
  String? get paymentGatewayDWValue => _paymentGatewayDWValue;

  String? _paymentMode;
  String? get paymentMode => _paymentMode;

  String? _paymentGatewayType;
  String? get paymentGatewayType => _paymentGatewayType;

  String? _paymentGatewayApiKey;
  String? get paymentGatewayApiKey => _paymentGatewayApiKey;

  String? _paymentGatewayApiSecret;
  String? get paymentGatewayApiSecret => _paymentGatewayApiSecret;

  // Invoice More item list
  List<PopupModel> _invoiceMoreList = [];
  List<PopupModel> get invoiceMoreList => _invoiceMoreList;

  createInvoiceMoreList() {
    _invoiceMoreList = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin!)
        PopupModel(
            image: Images.payment,
            title: 'due_payment_key',
            route: '',
            widget: DuePaymentDialog(
              previousRoute: Get.previousRoute,
            ),
            isRoute: false),
      if (Get.find<PermissionController>()
          .permissionModel!
          .customerDueInvoicePayment!)
        PopupModel(
            image: Images.addCustomer,
            title: 'customer_due_invoice_payment',
            route: '',
            widget: PaymentDialog(
              previousRoute: Get.previousRoute,
            ),
            isRoute: false),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateInvoices!)
        PopupModel(
            image: Images.edit,
            title: 'edit_key',
            route: RouteHelper.getCreateInvoiceRoute('2')),
      PopupModel(
          image: Images.viewDetails,
          title: 'view_details_key',
          route: RouteHelper.getInvoiceDetailsRoute()),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .sendAttachmentInvoice!)
        PopupModel(
          image: Images.resend,
          title: 'resend_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.resendDialogIcon,
            description: 'send_invoice_attachment_key',
            title: "are_you_sure_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().resendInvoice();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.manageInvoiceClone!)
        PopupModel(
          image: Images.clone,
          title: 'clone_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.cloneDialogIcon,
            description: 'this_invoice_will_be_cloned_key',
            title: "are_you_sure_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().cloneInvoice();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.downloadInvoice!)
        PopupModel(
          image: Images.download,
          title: 'download_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            imageHeight: 65,
            svgImagePath: Images.downloadAlert,
            title: "are_you_sure_key",
            description: 'you_want_to_download_this_invoice',
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().downloadPDF();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .downloadThermalInvoice!)
        PopupModel(
          image: Images.printingIcon,
          title: 'thermal_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            imageHeight: 65,
            svgImagePath: Images.downloadAlert,
            title: "are_you_sure_key",
            description: 'you_want_to_download_this_thermal_invoice',
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().downloadThermalInvoicePDF();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteInvoices!)
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
              Get.find<InvoiceController>().deleteInvoice();
            },
          ),
        ),
    ];
  }

  // Invoice More item list
  List<PopupModel> _invoiceMoreListWithoutDue = [];

  List<PopupModel> get invoiceMoreListWithoutDue => _invoiceMoreListWithoutDue;

  createInvoiceMoreListWithoutDue() {
    _invoiceMoreListWithoutDue = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateInvoices!)
        PopupModel(
            image: Images.edit,
            title: 'edit_key',
            route: RouteHelper.getCreateInvoiceRoute('2')),
      PopupModel(
          image: Images.viewDetails,
          title: 'view_details_key',
          route: RouteHelper.getInvoiceDetailsRoute()),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .sendAttachmentInvoice!)
        PopupModel(
          image: Images.resend,
          title: 'resend_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.resendDialogIcon,
            description: 'send_invoice_attachment_key',
            title: "are_you_sure_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().resendInvoice();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.manageInvoiceClone!)
        PopupModel(
          image: Images.clone,
          title: 'clone_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.cloneDialogIcon,
            description: 'this_invoice_will_be_cloned_key',
            title: "are_you_sure_key",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().cloneInvoice();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.downloadInvoice!)
        PopupModel(
          image: Images.download,
          title: 'download_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.downloadAlert,
            imageHeight: 65,
            title: "are_you_sure_key",
            description: "you_want_to_download_this_invoice",
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().downloadPDF();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>()
              .permissionModel!
              .downloadThermalInvoice!)
        PopupModel(
          image: Images.printingIcon,
          title: 'thermal_invoice_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            imageHeight: 65,
            svgImagePath: Images.downloadAlert,
            title: "are_you_sure_key",
            description: 'you_want_to_download_this_thermal_invoice',
            leftBtnTitle: 'no_key',
            rightBtnTitle: 'yes_key',
            rightBtnOnTap: () {
              Get.find<InvoiceController>().downloadThermalInvoicePDF();
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteInvoices!)
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
              Get.find<InvoiceController>().deleteInvoice();
            },
          ),
        ),
    ];
  }

  //  Set template list current index
  setTemplateListCurrentIndex(int value) {
    _invoiceTemplateListCurrentIndex = value;
    update();
  }

  //  Set customer list selected index
  setCustomerListSelectedIndex(int index) {
    _customerListSelectedIndex = index;
    update();
  }

  //  Set estimate status
  setInvoiceStatus(InvoiceStatus value) {
    _invoiceStatus = value;
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
    dueAmountCalculation();
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
        issueDateController.text = val;
      } else if (contain == 3) {
        if (issueDateController.text.compareTo(val) > 0) {
          showCustomSnackBar('wrong_date_key'.tr, isError: true);
        } else {
          dueDateController.text = val;
        }
      } else if (contain == 4) {
        duePaymentDateController.text = val;
      }
      update();
    }
  }

  // Invoice Quantity increment
  invoiceQuantityIncrement({required int index}) {
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
    dueAmountCalculation();
    update();
  }

  // Invoice Quantity decrement
  invoiceQuantityDecrement({required int index}) {
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
      dueAmountCalculation();
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
      dueAmountCalculation();
    } else if (quantity <= 0) {
      _selectedProductItemList[index].quantity.text = '1';
      _selectedProductItemList[index].totalPrice = double.parse(
          _selectedProductItemList[index].price.toStringAsFixed(2));
      subTotalCalculation();
      discountAmountCalculation();
      totalTaxCalculation();
      grandTotalCalculation();
      dueAmountCalculation();
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
      dueAmountCalculation();
    }
    update();
  }

  // Set payment method dw value
  setPaymentMethodDWValue(String? value) {
    _paymentMethodDWValue = value;
    update();
  }

  // Set payment gateway dw value
  setPaymentGatewayDWValue(type, api_key, api_secret, value, paymentMode) {
    _paymentGatewayType = type;
    _paymentGatewayApiKey = api_key;
    _paymentGatewayApiSecret = api_secret;
    _paymentGatewayDWValue = value;
    _paymentMode = paymentMode;
    update();
  }

  //getPaymentGateWay

  paymentGateWayFun(amount, invoiceNumberController, invoiceNameController) {
    if (_paymentGatewayType == "paypal") {
      Get.to(() => UsePaypal(
          sandboxMode: _paymentMode == "sandbox" ? true : false,
          clientId: "${_paymentGatewayApiKey}",
          secretKey: "${_paymentGatewayApiSecret}",
          returnURL: "https://samplesite.com/return",
          cancelURL: "https://samplesite.com/cancel",
          transactions: [
            {
              "amount": {
                "total": '${amount}',
                "currency": "USD",
                "details": {
                  "subtotal": '${amount}',
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The Invoice Number $invoiceNumberController.",
              "item_list": {
                "items": [
                  {
                    "name": "A demo product",
                    "quantity": 1,
                    "price": '${amount}',
                    "currency": "USD"
                  }
                ],
              }
            }
          ],
          note:
              "Contact us for any questions on your order.\nYour Invoice Number Is $invoiceNumberController.",
          onSuccess: (Map params) async {
            print("onSuccess: $params");
            paymentGatewayStatusUpdateMethod().then((value) {
              if (value.isSuccess) {
                getInvoice();
                Get.back();
                showCustomSnackBar(value.message, isError: false);

                if (Get.find<DashboardController>().bottomNavbarIndex == 0) {
                  final permissionData =
                      Get.find<PermissionController>().permissionModel;
                  if (permissionData!.isAppAdmin! ||
                      permissionData.dashboardStatisticsView!) {
                    Get.find<DashboardController>().getDashBoardData();
                  }
                  if (permissionData.isAppAdmin! ||
                      permissionData.incomeOverviewDashboard!) {
                    Get.find<DashboardController>().getIncomeOverview(
                        Get.find<DashboardController>()
                            .incomeOverviewFilterType[1]['value']!,
                        false);
                  }
                  if (permissionData.isAppAdmin! ||
                      permissionData.paymentOverviewDashboard!) {
                    Get.find<DashboardController>().getPaymentOverviewData();
                  }
                } else if (Get.find<DashboardController>().bottomNavbarIndex ==
                    1) {
                  Get.find<TransactionController>().getTransaction();
                }
              }
            });
            showCustomSnackBar("payment_success_key", isError: false);
          },
          onError: (error) {
            print("onError: $error");
            showCustomSnackBar("payment_error_key".tr + "\n\n$error",
                isError: true);
          },
          onCancel: (params) {
            print('cancelled: $params');
            showCustomSnackBar("payment_cancelled_key".tr + "\n\n$params",
                isError: true);
          }));
    } else if (_paymentGatewayType == "razorpay") {
      razorpayCheckout(amount, invoiceNumberController);
    } else if (_paymentGatewayType == "stripe") {
      double data = double.parse(amount);
      final castPayment = double.parse((data * 100).toString()).round();
      makeStripePaymentFun(amount: '${castPayment}', currency: 'USD');
    } else if (_paymentGatewayType == "sslcommerz") {
      sslPayCheckout(amount, invoiceNumberController, invoiceNameController);
    } else {
      showCustomSnackBar("payment_method_not_found".tr, isError: true);
      _duePaymentLoading = false;
    }
  }

  @override
  void onInit() {
    //razorpay...............
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    //razorpay...............

    super.onInit();
  }

  @override
  void dispose() {
    _razorpay.clear();
    paymentIntentData?.clear();
    super.dispose();
  }

  //razorpay...............

  late Razorpay _razorpay;

  void razorpayCheckout(dynamic amount, dynamic invoiceNumberController) {
    final price = double.tryParse(amount)! * 100;

    var options = {
      // 'key': 'rzp_test_lGm5FLE0Ty9evM', //<YOUR_KEY_ID>
      'key': '${_paymentGatewayApiKey}', //<YOUR_KEY_ID>
      "id": "$invoiceNumberController",
      "entity": "Due invoice",
      "amount": price,
      "currency": "INR",
      "receipt": "Due invoice number${invoiceNumberController}",
      "attempts": 0,
      "notes": [],
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    paymentGatewayStatusUpdateMethod().then((value) {
      if (value.isSuccess) {
        getInvoice();
        Get.back();
        showCustomSnackBar(value.message, isError: false);

        if (Get.find<DashboardController>().bottomNavbarIndex == 0) {
          final permissionData =
              Get.find<PermissionController>().permissionModel;
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
        } else if (Get.find<DashboardController>().bottomNavbarIndex == 1) {
          Get.find<TransactionController>().getTransaction();
        }
      }
    });
    showCustomSnackBar("payment_success_key".tr, isError: false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showCustomSnackBar("Payment Failure\n\n${response.message}", isError: true);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    showCustomSnackBar("External wallet \n\n${response.walletName}",
        isError: false);
  }

//razorpay...............

//ssl...............

  Future<void> sslPayCheckout(dynamic amount, dynamic invoiceNumberController,
      dynamic invoiceNameController) async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: "www.ipnurl.com",
        currency: SSLCurrencyType.BDT,
        product_category: "Service",
        sdkType:
            _paymentMode == "sandbox" ? SSLCSdkType.TESTBOX : SSLCSdkType.LIVE,
        store_id: "$_paymentGatewayApiKey",
        store_passwd: "$_paymentGatewayApiSecret",
        total_amount: double.parse(amount),
        tran_id: "${invoiceNumberController}",
      ),
    );

    sslcommerz
        .addEMITransactionInitializer(
            sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
                emi_options: 1, emi_max_list_options: 9, emi_selected_inst: 0))
        .addCustomerInfoInitializer(
          customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: "Bangladesh",
            customerName: invoiceNameController,
            customerEmail: "",
            customerAddress1: "Bangladesh",
            customerCity: "Bangladesh",
            customerPostCode: "0000",
            customerCountry: "Bangladesh",
            customerPhone: "",
          ),
        )
        .addProductInitializer(
            sslcProductInitializer:
                // ***** ssl product initializer for general product STARTS*****
                SSLCProductInitializer(
          productName: "Service",
          productCategory: "Service",
          general: General(
            general: "General Purpose",
            productProfile: "Product Profile",
          ),
        ))
        .addAdditionalInitializer(
          sslcAdditionalInitializer: SSLCAdditionalInitializer(
            valueA: "value a ",
            valueB: "value b",
            valueC: "value c",
            valueD: "value d",
            extras: {"key": "key", "key2": "key2"},
          ),
        );

    SSLCTransactionInfoModel result = await sslcommerz.payNow();

    print("result status ::${result.status ?? ""}");
    if (result.status!.toLowerCase() == "failed") {
      showCustomSnackBar("transaction_is_failed".tr + "\n\n${result.status}",
          isError: true);
    } else if (result.status!.toLowerCase() == "closed") {
      showCustomSnackBar(
          "payment_cancel_closed_by_uer".tr + "\n\n${result.status}",
          isError: true);
    } else {
      showCustomSnackBar("payment_success_key".tr, isError: false);
      paymentGatewayStatusUpdateMethod().then((value) {
        if (value.isSuccess) {
          getInvoice();
          Get.back();
          showCustomSnackBar(value.message, isError: false);

          if (Get.find<DashboardController>().bottomNavbarIndex == 0) {
            final permissionData =
                Get.find<PermissionController>().permissionModel;
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
          } else if (Get.find<DashboardController>().bottomNavbarIndex == 1) {
            Get.find<TransactionController>().getTransaction();
          }
        }
      });
    }
  }
//ssl...............

  //stripe

  Map<dynamic, dynamic>? paymentIntentData;

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      paymentGatewayStatusUpdateMethod().then((value) {
        if (value.isSuccess) {
          getInvoice();
          Get.back();
          showCustomSnackBar(value.message, isError: false);

          if (Get.find<DashboardController>().bottomNavbarIndex == 0) {
            final permissionData =
                Get.find<PermissionController>().permissionModel;
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
          } else if (Get.find<DashboardController>().bottomNavbarIndex == 1) {
            Get.find<TransactionController>().getTransaction();
          }
        }
      });
      showCustomSnackBar("payment_success_key".tr, isError: false);
    } on Exception catch (e) {
      if (e is StripeException) {
        print('error from stripe: ${e.error.localizedMessage}');
        showCustomSnackBar('${e.error.localizedMessage}', isError: true);
      } else {
        print("unforced error: $e");
        showCustomSnackBar("payment_cancelled_key".tr + "\n$e", isError: true);
      }
    } catch (e) {
      print("exception $e");
    }
  }

  createPaymentIntent(
      {required String amount, required String currency}) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "currency": currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization": "Bearer $_paymentGatewayApiSecret",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("CONNECT YOUR INTERNET CONNECTION..error charging user$e");
      showCustomSnackBar("$e", isError: true);
      // EasyLoading.showError("CONNECT YOUR INTERNET CONNECTION.. exception error charging user $e");
    }
  }

  Future<void> makeStripePaymentFun(
      {required String amount, required String currency}) async {
    Stripe.publishableKey = "$_paymentGatewayApiKey";

    try {
      paymentIntentData =
          await createPaymentIntent(amount: amount, currency: currency);

      var gPay = PaymentSheetGooglePay(
        merchantCountryCode: currency,
        currencyCode: currency,
        testEnv: true,
      );

      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          billingDetails: const BillingDetails(name: "", email: "", phone: ""),
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
                  phone: CollectionMode.always,
                  email: CollectionMode.always,
                  name: CollectionMode.always,
                  attachDefaultsToPaymentMethod: false),
          style: ThemeMode.dark,
          merchantDisplayName: "Prospects",
          customerId: paymentIntentData!["customer"],
          paymentIntentClientSecret: paymentIntentData!["client_secret"],
          customerEphemeralKeySecret: paymentIntentData!["ephemeralKey"],
          googlePay: gPay,
        ));
        displayPaymentSheet();
      }
    } catch (e, s) {
      print("exception:$e$s");
    }
  }

  //stripe

  // Get invoice data
  Future<ResponseModel> getInvoice(
      {bool isPaginate = false,
      bool fromFilter = false,
      bool isApplyFilter = false}) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _invoicePaginateLoading = true;
    } else {
      _invoiceList = [];
      _invoiceNextPageUrl = null;
      _invoiceListLoading = true;
      _isInvoiceFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    update();
    ResponseModel responseModel;
    if (fromFilter) {
      _selectedCustomerIdValue =
          _customerDropdownValue != null ? _customerDropdownValue : null;
      ;
      _filterIssueStartDateValue = _filterIssueStartDate;
      _filterDueStartDateValue = _filterDueStartDate;
      _filterIssueEndDateValue = filterIssueEndDate;
      _filterDueEndDateValue = filterDueEndDate;
    }
    final response = await invoiceRepo.getInvoice(
      url: invoiceNextPageUrl,
      customerId: _selectedCustomerIdValue != null
          ? _selectedCustomerIdValue.toString()
          : "",
      fromFilter: _isInvoiceFilter,
      status: _customerStatusId ?? "",
      issueStartDate: DateConverter.convertToDateTimeFormat(
          _filterIssueStartDateValue ?? ""),
      issueEndDate:
          DateConverter.convertToDateTimeFormat(_filterIssueEndDateValue ?? ""),
      dueStartDate:
          DateConverter.convertToDateTimeFormat(_filterDueStartDateValue ?? ""),
      dueEndDate:
          DateConverter.convertToDateTimeFormat(_filterDueEndDateValue ?? ""),
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _invoiceList.add(InvoiceModel.fromJson(item));
      });
      _invoiceNextPageUrl =
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
      _invoicePaginateLoading = false;
    } else {
      _invoiceListLoading = false;
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
      dueAmountCalculation();
      update();
    }
  }

  removeSelectedProductItem(int index) {
    _selectedProductItemList.removeAt(index);
    subTotalCalculation();
    discountAmountCalculation();
    totalTaxCalculation();
    grandTotalCalculation();
    dueAmountCalculation();
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
    final response = await invoiceRepo.getSuggestedDiscountType();
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
    dueAmountCalculation();
    update();
  }

  // Get suggested taxes data
  Future<void> getSuggestedTaxes() async {
    _suggestedAllItemListLoading = true;
    _suggestedTaxesList = [];
    _suggestedTaxesTitleList = [];
    update();
    final response = await invoiceRepo.getSuggestedTaxes();
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
        dueAmountCalculation();
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
    dueAmountCalculation();
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

  // Due amount calculation
  dueAmountCalculation() {
    if (_subTotal != null) {
      _dueAmount = 0.0;
      final getDueData = receivedAmountController.text;
      if (getDueData == '') {
        _dueAmount = _grandTotal;
      } else {
        _dueAmount = (_grandTotal! - double.parse(getDueData));
      }
      update();
    }
  }

  // Set selected invoice index
  setSelectedInvoiceIndex(int index) {
    _selectedInvoiceIndex = index;
  }

  clearInvoiceData() {
    _selectedProductItemList = [];
    _selectedTaxItemList = [];
    _getDBInvoiceIdList = [];
    _getDBTaxesIdList = [];
    chooseCustomerController.text = '';
    chooseProductController.text = '';
    refNumberController.text = '';
    discountAmountController.text = '';
    issueDateController.text = '';
    dueDateController.text = '';
    _selectedTemplate = null;
    _suggestedDiscountTypeDWValue = null;
    _suggestedTaxesDWValue = null;
    _dueAmount = 0.0;
    _discount = 0.0;
    _discountAmount = 0.0;
    _subTotal = 0.0;
    receivedAmountController.text = '';
    _grandTotal = 0.0;
  }

  // Create invoice
  Future<void> createInvoice({required String submitType}) async {
    if (submitType == '') {
      _createInvoiceSaveLoading = true;
    } else {
      _createInvoiceSendLoading = true;
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
    final issueDate =
        DateConverter.convertToDateTimeFormat(issueDateController.text);
    final dueDate =
        DateConverter.convertToDateTimeFormat(dueDateController.text);

    final response = await invoiceRepo.createInvoice(
      map: {
        'customer_id': customerDropdownValue.toString(),
        'due_date': dueDate,
        'issue_date': issueDate,
        'reference_number': refNumberController.text,
        'products': myProduct,
        'selected_invoice_template': _selectedTemplate,
        'discount_type': _suggestedDiscountTypeDWValue == "fixed"
            ? "fixed"
            : _suggestedDiscountTypeDWValue == "percentage"
                ? "percentage"
                : "none",
        'discount_amount': _discountAmount,
        'due_amount': _dueAmount,
        'sub_total': _subTotal,
        'submit_type': submitType,
        'taxes': myTaxes,
        'received_amount': receivedAmountController.text,
        'total_amount': (_subTotal! - _discountAmount!),
        'grand_total': _grandTotal,
        'note': "",
      },
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      Get.back();
      Get.toNamed(RouteHelper.invoiceScreen);
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _createInvoiceSaveLoading = false;
    _createInvoiceSendLoading = false;
    update();
  }

  // Get invoice details data
  Future<void> getInvoiceDetails() async {
    _getInvoiceDetailsLoading = true;
    _selectedProductItemList = [];
    _selectedTaxItemList = [];
    _getDBInvoiceIdList = [];
    _getDBTaxesIdList = [];
    update();
    final response = await invoiceRepo.getInvoiceDetails(
        id: _invoiceList[_selectedInvoiceIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      final data = response.body['result'];
      setCustomerDropdownValue(data['customer_id'].toString());
      setSelectedTemplate(data['invoice_template'] - 1);
      issueDateController.text =
          DateConverter.estimatedDate(DateTime.parse(data['issue_date']));
      dueDateController.text =
          DateConverter.estimatedDate(DateTime.parse(data['due_date']));
      refNumberController.text = data['reference_number'] ?? '';
      receivedAmountController.text = data['received_amount'] != null
          ? data['received_amount'].toString()
          : '0.00';
      data['discount_type'] == 'none'
          ? _suggestedDiscountTypeDWValue == null
          : setDiscountTypeDWValue(
              data['discount_type'] == 'fixed' ? "fixed" : "percentage");
      _noteTxt = data['note'];
      if (data['invoice_details'].isNotEmpty) {
        for (var item in data['invoice_details']) {
          _getDBInvoiceIdList.add(item['id']);
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
                taxId: (item['tax_id'] is String)
                    ? int.parse(item['tax_id'])
                    : item['tax_id'],
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
      dueAmountCalculation();
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    _getInvoiceDetailsLoading = false;
    update();
  }

  // Create invoice
  Future<void> updateInvoice({required String submitType}) async {
    if (submitType == '') {
      _updateInvoiceSaveLoading = true;
    } else {
      _updateInvoiceSendLoading = true;
    }
    update();
    List myProduct = [];
    List myTaxes = [];
    List myRemoveInvoiceList = [];
    List myRemoveTaxesList = [];
    for (var id in _getDBInvoiceIdList) {
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
        myRemoveInvoiceList.add(id);
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
      myProduct.add({
        'name': product.name,
        'price': product.price,
        'id': product.id,
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
        'id': tax.id,
      });
    }

    final issueDate =
        DateConverter.convertToDateTimeFormat(issueDateController.text);
    final dueDate =
        DateConverter.convertToDateTimeFormat(dueDateController.text);

    final response = await invoiceRepo.updateInvoice(
      map: {
        'customer_id': _customerDropdownValue.toString(),
        'due_date': dueDate,
        'issue_date': issueDate,
        'reference_number': refNumberController.text,
        'products': myProduct,
        'selected_invoice_template': _selectedTemplate,
        'discount_type': _suggestedDiscountTypeDWValue == "fixed"
            ? "fixed"
            : _suggestedDiscountTypeDWValue == "percentage"
                ? "percentage"
                : 'none',
        'discount_amount': _discountAmount,
        'due_amount': _dueAmount,
        'sub_total': _subTotal,
        'submit_type': submitType,
        'taxes': myTaxes,
        'received_amount': receivedAmountController.text,
        'total_amount': (_subTotal! - _discountAmount!),
        'grand_total': _grandTotal,
        'note': "",
        'remove_product': myRemoveInvoiceList,
        'remove_tax': myRemoveTaxesList,
      },
      id: _invoiceList[_selectedInvoiceIndex!].id!,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.offNamed(RouteHelper.invoiceScreen);
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getInvoice();
    } else {
      ApiChecker.checkApi(response);
    }
    _updateInvoiceSaveLoading = false;
    _updateInvoiceSendLoading = false;
    update();
  }

  // Resend invoice data
  Future<void> resendInvoice() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await invoiceRepo.resendInvoice(
        id: _invoiceList[_selectedInvoiceIndex!].id!);
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

  // Clone invoice data
  Future<void> cloneInvoice() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await invoiceRepo.cloneInvoice(
        id: _invoiceList[_selectedInvoiceIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getInvoice();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Delete invoice data
  Future<void> deleteInvoice() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await invoiceRepo.deleteInvoice(
        id: _invoiceList[_selectedInvoiceIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getInvoice();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Download invoice data
  Future<void> downloadInvoice() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response = await invoiceRepo.downloadInvoice(
        id: _invoiceList[_selectedInvoiceIndex!].id!);
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
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // View invoice data

  String? localFilePath;
  dynamic pdfPathList;
  bool isPdfLoading = false;

  Future<void> viewFile() async {
    try {
      isPdfLoading = true;
      final url =
          '${AppConstants.BASE_URL}${AppConstants.VIEW_INVOICE_URI}${_invoiceList[_selectedInvoiceIndex!].id}';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN) ?? "";

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
            '${dir.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

        final file = File(pdfPath);
        await file.writeAsBytes(response.bodyBytes);
        localFilePath = file.path;
        _selectedInvoiceIndex = null;
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
      // isPdfLoading = true;
      Get.find<ExpensesController>().setDialogLoading(true);
      update();
      final url =
          '${AppConstants.BASE_URL}${AppConstants.VIEW_INVOICE_URI}${_invoiceList[_selectedInvoiceIndex!].id}';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN) ?? "";

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
            '${dir.path}/${_invoiceList[_selectedInvoiceIndex!].invoiceNumber}.pdf';
        final file = File(pdfPath);
        await file.writeAsBytes(response.bodyBytes);
        localFilePath = file.path;
        _selectedInvoiceIndex = null;

        final result = await OpenFilex.open(localFilePath!);

        if (result.type != ResultType.done) {
          showCustomSnackBar('Error opening PDF'.tr, isError: true);
        }

        Get.find<ExpensesController>().setDialogLoading(false);
        Get.back();
        update();
      } else {
        // Handle non-200 responses
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
      // isPdfLoading = true;
      Get.find<ExpensesController>().setDialogLoading(true);
      update();
      final url =
          '${AppConstants.BASE_URL}${AppConstants.THERMAL_INVOICE_DOWNLOAD_URI}${_invoiceList[_selectedInvoiceIndex!].id}';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN) ?? "";

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
            '${dir.path}/${_invoiceList[_selectedInvoiceIndex!].invoiceNumber}.pdf';
        final file = File(pdfPath);
        await file.writeAsBytes(response.bodyBytes);
        localFilePath = file.path;
        _selectedInvoiceIndex = null;

        final result = await OpenFilex.open(localFilePath!);

        if (result.type != ResultType.done) {
          showCustomSnackBar('Error opening PDF'.tr, isError: true);
        }

        Get.find<ExpensesController>().setDialogLoading(false);
        Get.back();
        update();
      } else {
        // Handle non-200 responses
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
    _customerDropdownValue = null;
    _filterIssueStartDate = null;
    _filterIssueEndDate = null;
    _filterDueStartDate = null;
    _filterDueEndDate = null;
    _customerStatusId = null;
    _customerStatusDWValue = null;
    _selectedFilterCustomerItem = null;
    dueFilterController.text = '';
    issueFilterController.text = '';
    update();
  }

  bool isEmptyFilterForm() {
    if (_customerDropdownValue == null &&
        _filterIssueStartDate == null &&
        _filterIssueEndDate == null &&
        _filterDueStartDate == null &&
        _filterDueEndDate == null &&
        _customerStatusId == null &&
        _customerStatusDWValue == null &&
        _selectedFilterCustomerItem == null &&
        dueFilterController.text.isEmpty &&
        issueFilterController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void setCustomerId(String? value) {
    _customerDropdownValue = value;
    update();
  }

  void setFilterIssueStartDate(String? date) {
    _filterIssueStartDate = date;
    update();
  }

  void setFilterIssueEndDate(String? date) {
    _filterIssueEndDate = date;
    if (_filterIssueStartDate != null && _filterIssueEndDate != null) {
      issueFilterController.text =
          "${_filterIssueStartDate}  To  ${_filterIssueEndDate}";
    }
    update();
  }

  void setFilterDueStartDate(String? date) {
    _filterDueStartDate = date;
    update();
  }

  void setFilterDueEndDate(String? date) {
    _filterDueEndDate = date;
    if (_filterDueStartDate != null && _filterDueEndDate != null) {
      dueFilterController.text =
          "${_filterDueStartDate}  To  ${_filterDueEndDate}";
    }
    update();
  }

  // Set customer status dw value
  setCustomerStatusDWValue(String? value) {
    _customerStatusDWValue = value;
    _customerStatusId = value;

    update();
  }

  // Due Payment method
  Future<ResponseModel> duePayment(
      {required DuePaymentBody duePaymentBody}) async {
    _duePaymentLoading = true;
    update();
    Response response = await invoiceRepo.duePayment(
        duePaymentBody: duePaymentBody,
        id: _invoiceList[_selectedInvoiceIndex!].id!);
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
    _duePaymentLoading = false;
    update();
    return responseModel;
  }

  // Due Payment Gateway Status Update method
  Future<ResponseModel> paymentGatewayStatusUpdateMethod() async {
    _duePaymentLoading = true;
    update();
    Response response = await invoiceRepo.customerDuePayment(
        duePaymentBody: DuePaymentBody(
            receivedOn: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            payingAmount:
                formatCurrency(_invoiceList[_selectedInvoiceIndex!].dueAmount),
            paymentMethod: _paymentGatewayDWValue,
            note: ''),
        id: _invoiceList[_selectedInvoiceIndex!].id!);
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
    _duePaymentLoading = false;
    update();
    return responseModel;
  }

  paymentSuccess(value) {
    if (value.isSuccess) {
      getInvoice();
      Get.back();
      showCustomSnackBar(value.message, isError: false);

      if (Get.find<DashboardController>().bottomNavbarIndex == 0) {
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
      } else if (Get.find<DashboardController>().bottomNavbarIndex == 1) {
        Get.find<TransactionController>().getTransaction();
      }
    }
  }

  String formatCurrency(String? value) {
    String amount = value != null
        ? double.parse(value.replaceAll(RegExp(r'[^\d.]'), '')).toString()
        : "0.00";
    return amount;
  }

  void refreshData() {
    duePaymentDateController.text = '';
    _paymentMethodDWValue = null;
    _paymentGatewayDWValue = null;
    update();
  }

  // customer list Show in dropdown
  List<CustomerListModel> _customerDropdownList = [];

  List<CustomerListModel> get customerDropdownList => _customerDropdownList;

  List<Map<String, String>> _customerDropdownStringList = [];

  List<Map<String, String>> get customerDropdownStringList =>
      _customerDropdownStringList;

  String? _customerDropdownValue;

  String? get customerDropdownValue => _customerDropdownValue;

  int? _selectedCustomerIndex;

  int? get selectedCustomerIndex => _selectedCustomerIndex;

  String? _selectedCustomerIdValue;

  String? get selectedCustomerIdValue => _selectedCustomerIdValue;

  setCustomerDropdownValue(String? value) {
    _customerDropdownValue = value;
    update();
  }

  // Get customer list
  Future<void> getCustomerListDropdown() async {
    _suggestedAllItemListLoading = true;
    _customerDropdownList = [];
    _customerDropdownStringList = [];
    _customerDropdownValue = null;
    update();
    final response = await invoiceRepo.getCustomerListDropdown();
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

  // Set selected customer index
  setSelectedCustomerIndex(int index) {
    _selectedCustomerIndex = index;
  }

  // Product list Show in dropdown
  List<ProductListModel> _productDropdownList = [];

  List<ProductListModel> get productDropdownList => _productDropdownList;

  List<Map<String, String>> _productDropdownStringList = [];

  List<Map<String, String>> get productDropdownStringList =>
      _productDropdownStringList;

  String? _productDropdownValue;

  String? get productDropdownValue => _productDropdownValue;

  int? _selectedProductIndex;

  int? get selectedProductIndex => _selectedProductIndex;

  setProductDropdownValue(String? value) async {
    _productDropdownValue = value;
    int index = await productIdToProductDropdownListIndexConvert(value!);
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
    final response = await invoiceRepo.getProductListDropdown();
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

class SelectedProductItemModel {
  int? id;
  int productId;
  String name;
  double price;
  TextEditingController quantity;
  double totalPrice;

  SelectedProductItemModel({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });
}

class SelectedTaxItemModel {
  int? id;
  int taxId;
  String name;
  double rate;
  double totalTax;

  SelectedTaxItemModel({
    this.id,
    required this.taxId,
    required this.name,
    required this.rate,
    required this.totalTax,
  });
}
