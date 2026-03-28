import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/data/model/body/add_product_body.dart';
import 'package:invoicex/data/model/response/product_details_model.dart';
import 'package:invoicex/data/model/response/unit_model.dart';
import 'package:invoicex/data/repository/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:get/get.dart';
import '../data/api/api_checker.dart';
import '../data/model/body/popup_model.dart';
import '../data/model/response/product_model.dart';
import '../data/model/response/categories_model.dart';
import '../data/model/response/response_model.dart';
import '../util/images.dart';
import '../view/base/confirmation_dialog.dart';
import '../view/base/custom_snackbar.dart';
import 'expenses_controller.dart';

class ProductController extends GetxController implements GetxService {
  ProductRepo productRepo;
  ProductController({required this.productRepo});

  bool _isPaginateLoading = false;
  bool get isPaginateLoading => _isPaginateLoading;

  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  bool _isProductsLoading = false;
  bool get isProductsLoading => _isProductsLoading;

  bool _applyFilterLoading = false;
  bool get applyFilterLoading => _applyFilterLoading;

  String? _productsNextPageUrl;
  String? get productsNextPageUrl => _productsNextPageUrl;

  List<UnitModel> _unitList = [];
  List<UnitModel> get unitList => _unitList;

  List<Map<String, String>> _unitStringList = [];
  List<Map<String, String>> get unitStringList => _unitStringList;

  String? _unitsDWValue;
  String? get unitsDWValue => _unitsDWValue;

  String? _unitsFilterDWValue;
  String? get unitsFilterDWValue => _unitsFilterDWValue;
  String? _lowStockFilterDWValue;
  String? get lowStockFilterDWValue => _lowStockFilterDWValue;

  String? _unitsDWBackUpValue;
  String? get unitsDWBackUpValue => _unitsDWBackUpValue;

  bool _unitLoading = false;
  bool get unitLoading => _unitLoading;

  bool _addProductLoading = false;
  bool get addProductLoading => _addProductLoading;

  List<CategoriesModel> _productCategoryList = [];
  List<CategoriesModel> get productCategoryList => _productCategoryList;

  bool _productCategoryListLoading = false;
  bool get productCategoryListLoading => _productCategoryListLoading;

  bool _productCategoryPaginateLoading = false;
  bool get productCategoryPaginateLoading => _productCategoryPaginateLoading;

  bool _addProductCategoryLoading = false;
  bool get addProductCategoryLoading => _addProductCategoryLoading;

  String? _productCategoryNextPageUrl;
  String? get productCategoryNextPageUrl => _productCategoryNextPageUrl;

  List<UnitModel> _unitsManagementList = [];
  List<UnitModel> get unitsManagementList => _unitsManagementList;

  bool _unitsManagementLoading = false;
  bool get unitsManagementLoading => _unitsManagementLoading;

  bool _unitsManagementPaginateLoading = false;
  bool get unitsManagementPaginateLoading => _unitsManagementPaginateLoading;

  bool _addUnitLoading = false;
  bool get addUnitLoading => _addUnitLoading;

  int? _selectedProductCategoryIndex;
  int? get selectedProductCategoryIndex => _selectedProductCategoryIndex;

  int? _selectedUnitIndex;
  int? get selectedUnitIndex => _selectedUnitIndex;

  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController unitNameController = TextEditingController();

  List<PopupModel> _productCategoryMoreList = [];
  List<PopupModel> get productCategoryMoreList => _productCategoryMoreList;

  List<PopupModel> _unitMoreList = [];
  List<PopupModel> get unitMoreList => _unitMoreList;

  String? _unitsManagementNextPageUrl;
  String? get unitsManagementNextPageUrl => _unitsManagementNextPageUrl;

  bool _isProductUpdateLoading = false;
  bool get isProductUpdateLoading => _isProductUpdateLoading;

  static int _productSelectedId = -1;
  static int get productSelectedId => _productSelectedId;

  ProductDetailsModel? _productDetailsModel;
  ProductDetailsModel? get productDetailsModel => _productDetailsModel;

  bool _isProductDetailsLoading = false;
  bool get isProductDetailsLoading => _isProductDetailsLoading;

  int? _categoryListSelectedIndex;
  int? get categoryListSelectedIndex => _categoryListSelectedIndex;

  String? _categoriesDWValue;
  String? get categoriesDWValue => _categoriesDWValue;

  String? _categoriesDWBackUpValue;
  String? get categoriesDWBackUpValue => _categoriesDWBackUpValue;

  bool _isTransactionFilter = false;
  bool get isTransactionFilter => _isTransactionFilter;

  bool _suggestedAllItemListLoading = false;
  bool get suggestedAllItemListLoading => _suggestedAllItemListLoading;

  // Product More item list
  List<PopupModel> _productMoreList = [];
  List<PopupModel> get productMoreList => _productMoreList;
  createProductMoreList() {
    _productMoreList = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateProducts!)
        PopupModel(
            image: Images.edit,
            title: 'edit_key',
            route: RouteHelper.getAddProductRoute("1"),
            isRoute: true),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteProducts!)
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
              Get.find<ProductController>().deleteProduct();
            },
          ),
        ),
    ];
  }

  // Get All Products
  Future<ResponseModel> getProducts({
    bool isPaginate = false,
    bool fromFilter = false,
    bool isApplyFilter = false,
  }) async {
    if (isApplyFilter) {
      _applyFilterLoading = true;
    }
    if (isPaginate) {
      _isPaginateLoading = true;
    } else {
      _productList = [];
      _productsNextPageUrl = null;
      _isProductsLoading = true;
      _isTransactionFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    _suggestedAllItemListLoading = true;
    update();
    ResponseModel responseModel;
    if (fromFilter) {
      _categoriesDWBackUpValue =
          _categoriesDWValue != null ? _categoriesDWValue : "";
      _unitsDWBackUpValue =
          _unitsFilterDWValue != null ? _unitsFilterDWValue : "";
    }
    final response = await productRepo.getProducts(
        url: _productsNextPageUrl,
        fromFilter: _isTransactionFilter,
        category: _categoriesDWBackUpValue ?? "",
        unit: _unitsDWBackUpValue ?? "",
        lowStock: _lowStockFilterDWValue ?? "");
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _productList.add(ProductModel.fromJson(item));
      });
      _productsNextPageUrl =
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
      _isPaginateLoading = false;
    } else {
      _isProductsLoading = false;
    }

    _suggestedAllItemListLoading = false;
    update();
    return responseModel;
  }

  // Get units data
  Future<void> getUnits({bool isUpdate = false, int? unitId}) async {
    _unitLoading = true;
    _unitList = [];
    _unitStringList = [];
    _unitsDWValue = null;
    update();
    final response = await productRepo.getUnits();
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result'].forEach((item) {
        _unitList.add(UnitModel.fromJson(item));
        //  _unitStringList.add(item['name']);
        _unitStringList.add({
          'id': item['id'].toString(),
          'value': item['name'],
        });
      });
      if (isUpdate && unitId != null) {
        _unitsDWValue = unitId.toString();
        //  unitIdToNameConvert(unitId);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _unitLoading = false;
    update();
  }

  // Set unit dw value
  setUnitDWValue(String? value) {
    _unitsDWValue = value;
    update();
  }

  // Set unit filter dw value
  setFilterUnitDWValue(String? value) {
    _unitsFilterDWValue = value;
    update();
  }

  setLowStockFilterDWValue(String? value) {
    _lowStockFilterDWValue = value;
    update();
  }

  // Add Product
  Future<ResponseModel> addProduct(
      {required AddProductBody addProductBody}) async {
    _addProductLoading = true;
    update();
    Response response =
        await productRepo.addProduct(addProductBody: addProductBody);
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
    _addProductLoading = false;
    update();
    return responseModel;
  }

  Future<void> deleteProduct() async {
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await productRepo.deleteProduct(id: _productSelectedId);
    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getProducts();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  // Set product on tap id
  void setProductSelectedId({required int id}) {
    _productSelectedId = id;
    update();
  }

  // get Product Details
  Future<void> getProductDetails() async {
    _isProductDetailsLoading = true;
    _productDetailsModel = null;
    update();

    Response response =
        await productRepo.getProductDetails(id: _productSelectedId);
    if (response.statusCode == 200 && response.body['status'] == true) {
      _productDetailsModel =
          ProductDetailsModel.fromJson(response.body["result"]);
    } else {
      ApiChecker.checkApi(response);
    }
    _isProductDetailsLoading = false;
    update();
  }

  // Update Product
  Future<ResponseModel> updateProduct(
      {required AddProductBody addProductBody}) async {
    _isProductUpdateLoading = true;
    update();
    Response response = await productRepo.updateProduct(
        addProductBody: addProductBody, productId: _productSelectedId);
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      getProducts();
      responseModel = ResponseModel(
        true,
        response.body['message'],
      );
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    _isProductUpdateLoading = false;
    update();
    return responseModel;
  }



  Future<void> getProductCategoryList({bool isPaginate = false}) async {
    if (isPaginate) {
      _productCategoryPaginateLoading = true;
    } else {
      _productCategoryListLoading = true;
      _productCategoryList = [];
      _productCategoryNextPageUrl = null;
    }
    update();

    final response = await productRepo.getProductCategories(
      url: _productCategoryNextPageUrl,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _productCategoryList.add(CategoriesModel.fromJson(item));
      });
      _productCategoryNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
    } else {
      ApiChecker.checkApi(response);
    }

    if (isPaginate) {
      _productCategoryPaginateLoading = false;
    } else {
      _productCategoryListLoading = false;
    }
    update();
  }

  Future<ResponseModel> addProductCategory({required String name}) async {
    _addProductCategoryLoading = true;
    update();

    final response = await productRepo.addProductCategory(name: name);
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      await getProductCategoryList();
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }

    _addProductCategoryLoading = false;
    update();
    return responseModel;
  }

  void setSelectedProductCategoryIndex(int index) {
    _selectedProductCategoryIndex = index;
  }

  void createProductCategoryMoreList() {
    _productCategoryMoreList = [
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
            titleBodyWidget: Column(
              children: [
                Text('edit_key'.tr),
                const SizedBox(height: 16),
                GetBuilder<ProductController>(builder: (controller) {
                  return TextField(
                    controller: controller.categoryNameController,
                    decoration: InputDecoration(
                      hintText: 'write_category_name_here_key'.tr,
                    ),
                  );
                }),
                const SizedBox(height: 12),
              ],
            ),
            rightBtnOnTap: () {
              if (categoryNameController.text.trim().isEmpty) {
                showCustomSnackBar('please_enter_the_category_name_key'.tr,
                    isError: true);
                return;
              }
              editProductCategory(name: categoryNameController.text.trim());
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
              deleteProductCategory();
            },
          ),
        ),
    ];
  }

  Future<void> editProductCategory({required String name}) async {
    if (_selectedProductCategoryIndex == null) return;
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await productRepo.updateProductCategory(
      id: _productCategoryList[_selectedProductCategoryIndex!].id!,
      name: name,
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      await getProductCategoryList();
      await getCategories();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  Future<void> deleteProductCategory() async {
    if (_selectedProductCategoryIndex == null) return;
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await productRepo.deleteProductCategory(
      id: _productCategoryList[_selectedProductCategoryIndex!].id!,
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      await getProductCategoryList();
      await getCategories();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  Future<void> getUnitsManagementList({bool isPaginate = false}) async {
    if (isPaginate) {
      _unitsManagementPaginateLoading = true;
    } else {
      _unitsManagementLoading = true;
      _unitsManagementList = [];
      _unitsManagementNextPageUrl = null;
    }
    update();

    final response = await productRepo.getUnitsList(
      url: _unitsManagementNextPageUrl,
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _unitsManagementList.add(UnitModel.fromJson(item));
      });
      _unitsManagementNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
    } else {
      ApiChecker.checkApi(response);
    }

    if (isPaginate) {
      _unitsManagementPaginateLoading = false;
    } else {
      _unitsManagementLoading = false;
    }
    update();
  }

  Future<ResponseModel> addUnit({required String name}) async {
    _addUnitLoading = true;
    update();

    final response = await productRepo.addUnit(name: name);
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      await getUnitsManagementList();
      await getUnits();
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }

    _addUnitLoading = false;
    update();
    return responseModel;
  }

  void setSelectedUnitIndex(int index) {
    _selectedUnitIndex = index;
  }

  void createUnitMoreList() {
    _unitMoreList = [
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.updateUnits!)
        PopupModel(
          image: Images.edit,
          title: 'edit_key',
          route: '',
          isRoute: false,
          widget: ConfirmationDialog(
            leftBtnTitle: 'cancel_key',
            rightBtnTitle: 'save_key',
            titleBodyWidget: Column(
              children: [
                Text('edit_key'.tr),
                const SizedBox(height: 16),
                GetBuilder<ProductController>(builder: (controller) {
                  return TextField(
                    controller: controller.unitNameController,
                    decoration: InputDecoration(
                      hintText: 'write_unit_name_here_key'.tr,
                    ),
                  );
                }),
                const SizedBox(height: 12),
              ],
            ),
            rightBtnOnTap: () {
              if (unitNameController.text.trim().isEmpty) {
                showCustomSnackBar('please_enter_the_unit_name_key'.tr,
                    isError: true);
                return;
              }
              editUnit(name: unitNameController.text.trim());
            },
          ),
        ),
      if (Get.find<PermissionController>().permissionModel!.isAppAdmin! ||
          Get.find<PermissionController>().permissionModel!.deleteUnits!)
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
              deleteUnit();
            },
          ),
        ),
    ];
  }

  Future<void> editUnit({required String name}) async {
    if (_selectedUnitIndex == null) return;
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await productRepo.updateUnit(
      id: _unitsManagementList[_selectedUnitIndex!].id!,
      name: name,
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      await getUnitsManagementList();
      await getUnits();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  Future<void> deleteUnit() async {
    if (_selectedUnitIndex == null) return;
    Get.find<ExpensesController>().setDialogLoading(true);
    final response = await productRepo.deleteUnit(
      id: _unitsManagementList[_selectedUnitIndex!].id!,
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      await getUnitsManagementList();
      await getUnits();
    } else {
      ApiChecker.checkApi(response);
    }
    Get.find<ExpensesController>().setDialogLoading(false);
    update();
  }

  //  Set category list selected index
  setCategoryListSelectedIndex(int index) {
    _categoryListSelectedIndex = index;
    update();
  }

  void refreshFilterForm() {
    _categoriesDWValue = null;
    _unitsFilterDWValue = null;
    _lowStockFilterDWValue = null;
    _unitsDWValue = null;
    update();
  }

  bool isEmptyFilterForm() {
    if (_categoriesDWValue == null &&
        _unitsDWValue == null &&
        _unitsFilterDWValue == null &&
        _lowStockFilterDWValue == null) {
      return true;
    } else {
      return false;
    }
  }

  // Set category dw value
  setCategoriesDWValue(String? value) {
    _categoriesDWValue = value;
    update();
  }
}
