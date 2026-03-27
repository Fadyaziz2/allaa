import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/data/api/api_checker.dart';
import 'package:invoicex/data/model/response/tax_model.dart';
import 'package:invoicex/data/repository/tax_repo.dart';
import 'package:invoicex/view/base/custom_snackbar.dart';
import 'package:invoicex/view/screens/taxes/widget/edit_taxes_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/model/body/popup_model.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import 'expenses_controller.dart';

class TaxesController extends GetxController implements GetxService {
  final TaxRepo taxRepo;
  TaxesController({required this.taxRepo});

  List<TaxModel> _taxList = [];
  List<TaxModel> get taxList => _taxList;

  bool _taxListLoading = false;
  bool get taxListLoading => _taxListLoading;

  bool _taxPaginateLoading = false;
  bool get taxPaginateLoading => _taxPaginateLoading;

  String? _taxNextPageUrl;
  String? get taxNextPageUrl => _taxNextPageUrl;

  final taxNameController = TextEditingController();
  final taxRateController = TextEditingController();
  final editTaxNameController = TextEditingController();
  final editTaxRateController = TextEditingController();

  final taxNameFocusNode = FocusNode();
  final taxRateFocusNode = FocusNode();
  final editTaxNameNode = FocusNode();
  final editTaxRateNode = FocusNode();

  bool _addTaxLoading = false;
  bool get addTaxLoading => _addTaxLoading;

  int? _selectedTaxIndex;
  int? get selectedTaxIndex => _selectedTaxIndex;

  bool _editTaxLoading = false;
  bool get editTaxLoading => _editTaxLoading;

  final bool _deleteTaxLoading = false;
  bool get deleteTaxLoading => _deleteTaxLoading;

  bool _isDialogLoading = false;
  bool get isDialogLoading => _isDialogLoading;

  // Taxes More item list
  List<PopupModel> _taxesMoreList = [];
  List<PopupModel> get taxesMoreList => _taxesMoreList;
  createTaxesMoreList() {
    _taxesMoreList = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateTaxes!)
        PopupModel(
            image: Images.edit,
            title: 'edit_key'.tr,
            route: '',
            widget: EditTaxesDialog(),
            isRoute: false),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteTaxes!)
        PopupModel(
          image: Images.delete,
          title: 'delete_key'.tr,
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            svgImagePath: Images.deleteDialogIcon,
            description: 'this_content_will_be_deleted_key'.tr,
            title: "you_want_to_delete_key".tr,
            leftBtnTitle: 'no_key'.tr,
            rightBtnTitle: 'yes_key'.tr,
            rightBtnOnTap: () {
              Get.find<TaxesController>().deleteTax();
            },
          ),
        ),
    ];
  }

  // Get notes data
  Future<void> getTax({bool isPaginate = false}) async {
    if (isPaginate) {
      _taxPaginateLoading = true;
    } else {
      _taxListLoading = true;
      _taxList = [];
      _taxNextPageUrl = null;
    }
    update();
    final response = await taxRepo.getTax(url: taxNextPageUrl);
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _taxList.add(TaxModel.fromJson(item));
      });
      _taxNextPageUrl = response.body['result']['pagination']['next_page_url'];
    } else {
      _taxListLoading = false;
      _taxPaginateLoading = false;
      update();
      ApiChecker.checkApi(response);
    }
    if (isPaginate) {
      _taxPaginateLoading = false;
    } else {
      _taxListLoading = false;
    }
    update();
  }

  // Add notes data
  Future<void> addTax() async {
    _addTaxLoading = true;
    update();
    var taxRate = taxRateController.text;
    final response =
        await taxRepo.addTax(taxName: taxNameController.text, taxRate: taxRate);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();

      showCustomSnackBar(response.body['message'], isError: false);
      getTax();
    } else {
      ApiChecker.checkApi(response);
    }
    _addTaxLoading = false;
    update();
  }

  // Set selected note index
  setSelectedTaxIndex(int index) {
    _selectedTaxIndex = index;
  }

  // Edit expenses category data
  Future<void> editTax() async {
    _editTaxLoading = true;
    update();
    final response = await taxRepo.editTax(
        id: _taxList[_selectedTaxIndex!].id!,
        editTaxName: editTaxNameController.text,
        editTaxRate: editTaxRateController.text);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getTax();
    } else {
      ApiChecker.checkApi(response);
    }
    _editTaxLoading = false;
    update();
  }

  setDialogLoading(bool value) {
    _isDialogLoading = value;
    update();
  }

  // Delete Note data
  Future<void> deleteTax() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    update();
    final response =
        await taxRepo.deleteTax(id: _taxList[_selectedTaxIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getTax();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  void refreshData({required bool isUpdate}) {
    if (isUpdate) {
      editTaxNameController.text = '';
      editTaxRateController.text = '';
    } else {
      taxNameController.text = '';
      taxRateController.text = '';
    }
  }
}
