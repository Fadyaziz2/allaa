import 'dart:convert';

import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/data/api/api_client.dart';
import 'package:invoicex/data/model/response/expenses_category_model.dart';
import 'package:invoicex/data/model/response/expenses_details_model.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/api/api_checker.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/categories_model.dart';
import '../data/model/response/exexpenses_model.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/expenses_repo.dart';
import '../helper/date_converter.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';
import '../view/screens/expenses/widget/edit_dialog_body.dart';

class ExpensesController extends GetxController implements GetxService {
  final ExpensesRepo expensesRepo;
  ExpensesController({required this.expensesRepo});

  final searchController = TextEditingController();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final refNumberController = TextEditingController();
  final noteController = TextEditingController();
  final categorySearchController = TextEditingController();
  final addCategoryController = TextEditingController();
  final editCategoryController = TextEditingController();
  final dateController = TextEditingController();
  final filterController = TextEditingController();
  final expensesReportFilterController = TextEditingController();

  final searchFocusNode = FocusNode();
  final titleFocusNode = FocusNode();
  final amountFocusNode = FocusNode();
  final refNumberFocusNode = FocusNode();
  final noteFocusNode = FocusNode();
  final categorySearchFocusNode = FocusNode();

  String? _dateRangeStartDate;
  String? get dateRangeStartDate => _dateRangeStartDate;

  String? _dateRangeEndDate;
  String? get dateRangeEndDate => _dateRangeEndDate;

  int? _customerListSelectedIndex;
  int? get customerListSelectedIndex => _customerListSelectedIndex;

  List<ExpensesModel> _expensesList = [];
  List<ExpensesModel> get expensesList => _expensesList;

  bool _expensesListLoading = false;
  bool get expensesListLoading => _expensesListLoading;

  bool _applyFilterLoading = false;
  bool get applyFilterLoading => _applyFilterLoading;

  bool _expensesPaginateLoading = false;
  bool get expensesPaginateLoading => _expensesPaginateLoading;

  String? _expensesNextPageUrl;
  String? get expensesNextPageUrl => _expensesNextPageUrl;

  int? _selectedExpensesIndex;
  int? get selectedExpensesIndex => _selectedExpensesIndex;

  List<CategoriesModel> _categoriesList = [];
  List<CategoriesModel> get categoriesList => _categoriesList;

  List<Map<String, String>> _categoriesStringList = [];
  List<Map<String, String>> get categoriesStringList => _categoriesStringList;

  String? _categoriesDWValue;
  String? get categoriesDWValue => _categoriesDWValue;

  bool _categoriesLoading = false;
  bool get categoriesLoading => _categoriesLoading;

  bool _addExpensesLoading = false;
  bool get addExpensesLoading => _addExpensesLoading;

  bool _updateExpensesLoading = false;
  bool get updateExpensesLoading => _updateExpensesLoading;

  List<ExpensesCategoryModel> _expensesCategoryList = [];
  List<ExpensesCategoryModel> get expensesCategoryList => _expensesCategoryList;

  bool _expensesCategoryListLoading = false;
  bool get expensesCategoryListLoading => _expensesCategoryListLoading;

  bool _expensesCategoryFilterLoading = false;
  bool get expensesCategoryFilterLoading => _expensesCategoryFilterLoading;

  bool _expensesCategoryPaginateLoading = false;
  bool get expensesCategoryPaginateLoading => _expensesCategoryPaginateLoading;

  String? _expensesCategoryNextPageUrl;
  String? get expensesCategoryNextPageUrl => _expensesCategoryNextPageUrl;

  int? _selectedExpensesCategoryIndex;
  int? get selectedExpensesCategoryIndex => _selectedExpensesCategoryIndex;

  bool _isDialogLoading = false;
  bool get isDialogLoading => _isDialogLoading;

  bool _isExpensesDetailsLoading = false;
  bool get isExpensesDetailsLoading => _isExpensesDetailsLoading;

  ExpensesDetailsModel? _expensesDetailsModel;
  ExpensesDetailsModel? get expensesDetailsModel => _expensesDetailsModel;

  String? _filterStartDate;
  String? get filterStartDate => _filterStartDate;

  String? _filterStartDateValue;
  String? get filterStartDateValue => _filterStartDateValue;

  String? _filterEndDate;
  String? get filterEndDate => _filterEndDate;

  String? _filterEndDateValue;
  String? get filterEndDateValue => _filterEndDateValue;

  bool _isExpensesFilter = false;
  bool get isExpensesFilter => _isExpensesFilter;

  String? _expensesCategoriesDWValue;
  String? get expensesCategoriesDWValue => _expensesCategoriesDWValue;

  List<MyFile> _myFiles = [];
  List<MyFile> get myFiles => _myFiles;

  List<int> _getDBAttachmentIdList = [];

  // Set expenses category dw value
  setExpensesCategoriesDWValue(String? value) {
    _expensesCategoriesDWValue = value;
    update();
  }

  // set empty picked files
  setEmptyPickedFiles() {
    _myFiles = [];
  }

  //  Set customer list selected index
  setCustomerListSelectedIndex(int index) {
    _customerListSelectedIndex = index;
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
      if (kDebugMode) {
        print(picked);
      }
      final val = DateConverter.estimatedDate(picked);
      if (contain == 0) {
        _dateRangeStartDate = val;
      } else if (contain == 1) {
        _dateRangeEndDate = val;
      } else if (contain == 2) {
        dateController.text = val;
      }
      update();
    }
  }

  // Picked file function
  pickedFile() async {
    double allItemSize = 0;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpeg',
        'jpg',
        'gif',
        'png',
        'pdf',
        'zip',
        'doc',
        'xls'
      ],
    );
    if (result != null) {
      for (var item in result.files) {
        allItemSize += item.size / 1024;
      }
      if (allItemSize <= 2048) {
        for (var data in result.files) {
          String? fileName;
          List<String> parts = data.path!.split('/');
          fileName = parts.last;
          if (fileName.contains('_')) {
            List<String> parts = fileName.split('_');
            fileName = parts.last;
          }
          if (fileName.contains('-')) {
            List<String> parts = fileName.split('-');
            fileName = parts.last;
          }
          _myFiles.add(
            MyFile(
              file: XFile(data.path!),
              type: data.extension ?? '',
              name: fileName,
            ),
          );
        }
      } else {
        showCustomSnackBar('Max_file_size_is_2_MB_key'.tr);
      }
    }
    update();
  }

  // Picked camera function
  pickedCamera() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear);

    if (pickedFile != null) {
      String? fileName;
      List<String> parts = pickedFile.path.split('/');
      fileName = parts.last;
      if (fileName.contains('_')) {
        List<String> parts = fileName.split('_');
        fileName = parts.last;
      }
      if (fileName.contains('-')) {
        List<String> parts = fileName.split('-');
        fileName = parts.last;
      }
      _myFiles.add(
        MyFile(
          file: XFile(pickedFile.path),
          type: '',
          name: fileName,
        ),
      );
    }

    update();
  }

  removePickedFileByIndex({required int index}) {
    print("removePickedFileByIndex: $index");
    _myFiles.removeAt(index);
    update();
  }

  // Expenses More item list
  List<PopupModel> _expensesMoreList = [];
  List<PopupModel> get expensesMoreList => _expensesMoreList;
  createExpensesMoreList() {
    _expensesMoreList = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateExpenses!)
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: RouteHelper.getAddExpensesRoute('1'),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteExpenses!)
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
              Get.find<ExpensesController>().deleteExpenses();
            },
          ),
        ),
    ];
  }

  // Expenses Category More item list
  List<PopupModel> _expensesCategoryMoreList = [];
  List<PopupModel> get expensesCategoryMoreList => _expensesCategoryMoreList;
  createExpensesCategoryMoreList() {
    _expensesCategoryMoreList = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateCategories!)
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            leftBtnTitle: 'cancel_key',
            rightBtnTitle: 'save_key',
            titleBodyWidget: const EditDialogBody(),
            rightBtnOnTap: () {
              if (Get.find<ExpensesController>()
                  .editCategoryController
                  .text
                  .isEmpty) {
                showCustomSnackBar('please_enter_the_category_name_key'.tr,
                    isError: true);
              } else {
                Get.find<ExpensesController>().editExpensesCategory();
              }
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteCategories!)
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
              Get.find<ExpensesController>().deleteExpensesCategory();
            },
          ),
        ),
    ];
  }

  // Get expenses data
  Future<ResponseModel> getExpenses({
    bool isPaginate = false,
    bool fromFilter = false,
    bool isApplyFilter = false,
  }) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _expensesPaginateLoading = true;
    } else {
      _expensesList = [];
      _expensesNextPageUrl = null;
      _expensesListLoading = true;
      _isExpensesFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    update();
    ResponseModel responseModel;
    if (fromFilter) {
      update();
      _expensesCategoriesDWValue = _expensesCategoriesDWValue != null
          ? _expensesCategoriesDWValue
          : null;
      _filterStartDateValue = _filterStartDate;
      _filterEndDateValue = filterEndDate;
    }
    final response = await expensesRepo.getExpenses(
      url: expensesNextPageUrl,
      fromFilter: _isExpensesFilter,
      categoryId: _expensesCategoriesDWValue != null
          ? _expensesCategoriesDWValue
          : null,
      startDate:
          DateConverter.convertToDateTimeFormat(_filterStartDateValue ?? ""),
      endDate: DateConverter.convertToDateTimeFormat(_filterEndDateValue ?? ""),
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _expensesList.add(ExpensesModel.fromJson(item));
      });
      _expensesNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(true, response.body['message']);
    }
    if (isApplyFilter) {
      _applyFilterLoading = false;
    }
    if (isPaginate) {
      _expensesPaginateLoading = false;
    } else {
      _expensesListLoading = false;
    }
    update();
    return responseModel;
  }

  // Get categories data
  Future<void> getCategories(
      {bool isUpdate = false,
      int? categoryId,
      required bool fromProduct}) async {
    _categoriesLoading = true;
    _categoriesList = [];
    _categoriesStringList = [];
    _categoriesDWValue = null;
    update();
    final response = await expensesRepo.getCategories(fromProduct);
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result'].forEach((item) {
        _categoriesList.add(CategoriesModel.fromJson(item));
        _categoriesStringList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });

      if (isUpdate && categoryId != null) {
        _categoriesDWValue = categoryId.toString();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _categoriesLoading = false;
    update();
  }

  // Set category dw value
  setCategoriesDWValue(String? value) {
    _categoriesDWValue = value;
    update();
  }

  // Add expenses data
  Future<void> addExpenses() async {
    _addExpensesLoading = true;
    update();
    print(categoriesDWValue);
    List<MultipartBody> filesList = [];
    for (int i = 0; i < _myFiles.length; i++) {
      filesList.add(MultipartBody('attachments[$i]', _myFiles[i].file));
    }
    final response = await expensesRepo.addExpenses(
      map: {
        'title': titleController.text,
        'date': dateController.text,
        'amount': amountController.text,
        'category_id': categoriesDWValue.toString(),
        'reference': refNumberController.text,
        'note': noteController.text,
      },
      files: filesList,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      if (Get.previousRoute == RouteHelper.getExpansesRoute()) {
        getExpenses();
      } else {
        Get.toNamed(RouteHelper.getExpansesRoute());
      }
      showCustomSnackBar(response.body['message'], isError: false);
      refreshFromData();
    } else {
      _addExpensesLoading = false;
      update();
      ApiChecker.checkApi(response);
    }
    _addExpensesLoading = false;
    update();
  }

// Update expenses data
  Future<void> updateExpenses() async {
    _updateExpensesLoading = true;
    update();

    List<MultipartBody> filesList = [];

    // Prepare the files list
    for (int i = 0; i < _myFiles.length; i++) {
      // Only add new files
      if (!_myFiles[i].file.path.contains('/storage/attachments/')) {
        filesList.add(MultipartBody('attachments[$i]', _myFiles[i].file));
      }
    }

    // Determine which attachments to remove
    List<int> myRemoveAttachmentIdList = _getDBAttachmentIdList.where((dbId) {
      return !_myFiles.any((file) => file.id == dbId);
    }).toList();

    // Prepare the request payload
    Map<String, String> payload = {
      'title': titleController.text,
      'date': dateController.text,
      'amount': amountController.text,
      'category_id': categoriesDWValue.toString(),
      'reference': refNumberController.text,
      'note': noteController.text,
      'remove_attachments': jsonEncode(myRemoveAttachmentIdList),
    };

    // Make the API call
    final response = await expensesRepo.updateExpenses(
      map: payload,
      files: filesList,
      id: _expensesList[_selectedExpensesIndex!].id!,
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      refreshFromData();
      getExpenses();
    } else {
      ApiChecker.checkApi(response);
    }

    _updateExpensesLoading = false;
    update();
  }

  // Set selected expenses index
  setSelectedExpensesIndex(int index) {
    _selectedExpensesIndex = index;
  }

  void refreshFromData() {
    titleController.text = '';
    dateController.text = '';
    amountController.text = '';
    refNumberController.text = '';
    noteController.text = '';
    _getDBAttachmentIdList = [];
    setEmptyPickedFiles();
  }

  // Delete expenses data
  Future<void> deleteExpenses() async {
    _isDialogLoading = true;
    update();
    final response = await expensesRepo.deleteExpenses(
        id: _expensesList[_selectedExpensesIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getExpenses();
    } else {
      ApiChecker.checkApi(response);
    }
    _isDialogLoading = false;
    update();
  }

  // Get expenses category data
  Future<bool> getExpensesCategory({
    bool isPaginate = false,
    String? searchKey,
  }) async {
    bool isSucess = false;

    if (isPaginate) {
      _expensesCategoryPaginateLoading = true;
    } else {
      _expensesCategoryList = [];
      _expensesCategoryNextPageUrl = null;
      _expensesCategoryListLoading = true;
    }
    update();
    final response = await expensesRepo.getExpensesCategory(
      url: expensesCategoryNextPageUrl,
      searchKey: searchKey,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _expensesCategoryList.add(ExpensesCategoryModel.fromJson(item));
      });
      _expensesCategoryNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
      isSucess = true;
    } else {
      isSucess = false;
      ApiChecker.checkApi(response);
    }

    if (isPaginate) {
      _expensesCategoryPaginateLoading = false;
    } else {
      _expensesCategoryListLoading = false;
    }
    update();
    return isSucess;
  }

  // Add expenses category data
  Future<void> addExpensesCategory() async {
    _isDialogLoading = true;
    update();
    final response = await expensesRepo.addExpensesCategory(
        catName: addCategoryController.text);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      addCategoryController.text = '';
      showCustomSnackBar(response.body['message'], isError: false);
      getExpensesCategory();
    } else {
      ApiChecker.checkApi(response);
    }
    _isDialogLoading = false;
    update();
  }

  // Set selected expenses category index
  setSelectedExpensesCategoryIndex(int index) {
    _selectedExpensesCategoryIndex = index;
  }

  // Edit expenses category data
  Future<void> editExpensesCategory() async {
    _isDialogLoading = true;
    update();
    final response = await expensesRepo.editExpensesCategory(
        id: _expensesCategoryList[_selectedExpensesCategoryIndex!].id!,
        name: editCategoryController.text);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      editCategoryController.text = '';
      showCustomSnackBar(response.body['message'], isError: false);
      getExpensesCategory();
    } else {
      ApiChecker.checkApi(response);
    }
    _isDialogLoading = false;
    update();
  }

  // Delete expenses category data
  Future<void> deleteExpensesCategory() async {
    _isDialogLoading = true;
    update();
    final response = await expensesRepo.deleteExpensesCategory(
        id: _expensesCategoryList[_selectedExpensesCategoryIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getExpensesCategory();
    } else {
      ApiChecker.checkApi(response);
    }
    _isDialogLoading = false;
    update();
  }

  setDialogLoading(bool value) {
    _isDialogLoading = value;
    update();
  }

  // Get expenses details data
  Future<void> getExpensesDetails() async {
    _isExpensesDetailsLoading = true;
    _expensesDetailsModel = null;
    update();
    final response = await expensesRepo.getExpensesDetails(
        id: _expensesList[_selectedExpensesIndex!].id!);
    if (response.statusCode == 200 && response.body['status'] == true) {
      _expensesDetailsModel =
          ExpensesDetailsModel.fromJson(response.body['result']);
      titleController.text = _expensesDetailsModel!.title ?? "";
      amountController.text = _expensesDetailsModel!.amount.toString();
      refNumberController.text = _expensesDetailsModel!.reference ?? "";
      noteController.text = _expensesDetailsModel!.note ?? "";
      if (_expensesDetailsModel!.date != null) {
        dateController.text = DateConverter.estimatedDate(
            DateTime.parse(_expensesDetailsModel!.date!));
      }
      if (_expensesDetailsModel!.attachments != null) {
        for (var data in _expensesDetailsModel!.attachments!) {
          String? fileName;
          String? extension;
          List<String> parts = data.path!.split('/');
          fileName = parts.last;
          if (fileName.contains('_')) {
            List<String> parts = fileName.split('_');
            fileName = parts.last;
          }
          if (fileName.contains('-')) {
            List<String> parts = fileName.split('-');
            fileName = parts.last;
          }
          List<String> extParts = fileName.split('.');
          extension = extParts.last;
          _myFiles.add(
            MyFile(
              id: data.id,
              file: XFile(data.path!),
              type: extension,
              name: fileName,
            ),
          );
          _getDBAttachmentIdList.add(data.id!);
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isExpensesDetailsLoading = false;
    update();
  }

  void setFilterStartDate(String? date) {
    _filterStartDate = date;
    update();
  }

  void setFilterEndDate(String? date, {bool isReport = false}) {
    _filterEndDate = date;
    if (filterStartDate != null && filterEndDate != null) {
      if (isReport) {
        expensesReportFilterController.text =
            "${filterStartDate}  To  ${filterEndDate}";
      } else {
        filterController.text = "${filterStartDate}  To  ${filterEndDate}";
      }
    }
    update();
  }

  void refreshFilterForm() {
    _filterStartDate = null;
    _filterEndDate = null;
    expensesReportFilterController.text = '';
    filterController.text = '';
    setExpensesCategoriesDWValue(null);
    update();
  }

  bool isEmptyFilterForm() {
    if (_filterStartDate == null &&
        _filterEndDate == null &&
        expensesReportFilterController.text.isEmpty &&
        filterController.text.isEmpty &&
        _expensesCategoriesDWValue == null) {
      return true;
    } else {
      return false;
    }
  }
}

class MyFile {
  int? id;
  XFile file;
  String? type;
  String name;

  MyFile({
    this.id,
    required this.file,
    this.type,
    required this.name,
  });
}
