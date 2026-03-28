import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/wastage_model.dart';
import '../data/repository/wastage_repo.dart';
import '../view/base/custom_snackbar.dart';

class WastageController extends GetxController implements GetxService {
  final WastageRepo wastageRepo;
  WastageController({required this.wastageRepo});

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<WastageModel> _wastageList = [];
  List<WastageModel> get wastageList => _wastageList;

  List<Map<String, String>> _products = [];
  List<Map<String, String>> get products => _products;

  List<Map<String, String>> _categories = [];
  List<Map<String, String>> get categories => _categories;

  String? _nextPageUrl;
  String? get nextPageUrl => _nextPageUrl;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginateLoading = false;
  bool get isPaginateLoading => _isPaginateLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? selectedProductId;
  String? selectedCategoryId;

  Future<void> initFormData() async {
    quantityController.clear();
    noteController.clear();
    selectedProductId = null;
    await Future.wait([getSelectableProducts(), getCategories()]);
  }

  Future<void> getSelectableProducts() async {
    final response = await wastageRepo.getSelectableProducts();
    if (response.statusCode == 200) {
      _products = [];
      final rawProducts = response.body?['result']?['data'] ?? response.body?['data'] ?? [];
      if (rawProducts is! Iterable) {
        update();
        return;
      }
      for (final item in rawProducts) {
        _products.add({'id': item['id'].toString(), 'name': item['name'].toString()});
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getCategories() async {
    final response = await wastageRepo.getCategories();
    if (response.statusCode == 200) {
      _categories = [];
      final rawCategories =
          response.body?['result']?['data'] ?? response.body?['result'] ?? response.body?['data'] ?? [];
      if (rawCategories is! Iterable) {
        update();
        return;
      }
      for (final item in rawCategories) {
        _categories.add({'id': item['id'].toString(), 'name': item['name'].toString()});
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getWastages({bool isPaginate = false}) async {
    if (isPaginate) {
      _isPaginateLoading = true;
    } else {
      _isLoading = true;
      _wastageList = [];
      _nextPageUrl = null;
    }
    update();

    final response = await wastageRepo.getWastages(
      url: isPaginate ? _nextPageUrl : null,
      categoryId: selectedCategoryId,
      productId: selectedProductId,
    );

    if (response.statusCode == 200) {
      final result = response.body['result'];
      for (final item in result['data']) {
        _wastageList.add(WastageModel.fromJson(item));
      }
      _nextPageUrl = result['pagination']['next_page_url'];
    } else {
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    _isPaginateLoading = false;
    update();
  }

  Future<bool> addWastage() async {
    if (selectedProductId == null || quantityController.text.trim().isEmpty) {
      showCustomSnackBar('please_fill_all_fields_key'.tr);
      return false;
    }

    _isSubmitting = true;
    update();

    final response = await wastageRepo.addWastage({
      'product_id': selectedProductId,
      'quantity': quantityController.text.trim(),
      'note': noteController.text.trim(),
    });

    _isSubmitting = false;
    update();

    if (response.statusCode == 200 || response.statusCode == 201) {
      await getWastages();
      return true;
    }

    ApiChecker.checkApi(response);
    return false;
  }

  void setFilterCategory(String? id) {
    selectedCategoryId = id;
    update();
  }

  void setFilterProduct(String? id) {
    selectedProductId = id;
    update();
  }
}
