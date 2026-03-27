import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/api_checker.dart';
import '../data/model/response/permission_model.dart';
import '../data/repository/permission_repo.dart';
import '../util/app_constants.dart';

class PermissionController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  final PermissionRepo permissionRepo;

  PermissionController({
    required this.sharedPreferences,
    required this.permissionRepo,
  });

  // PermissionModel
  PermissionModel? permissionModel;

  // Loading
  bool _permissionLoading = false;
  bool get permissionLoading => _permissionLoading;

  // Create count
  int _createCount = 0;
  int get createCount => _createCount;

  // App logo
  String? _appLogo;
  String? get appLogo => _appLogo;

  // Get units data
  Future<void> getPermission() async {
    _permissionLoading = true;
    update();
    final response = await permissionRepo.getPermission();
    if (response.statusCode == 200 && response.body['status'] == true) {
      permissionModel =
          PermissionModel.fromJson(response.body['result']['permissions']);
      sharedPreferences.setString(AppConstants.APP_LOGO,
          response.body['result']['company']['company_logo']);
      Get.find<PermissionController>().setPermissionInfo();
    } else {
      ApiChecker.checkApi(response);
    }
    _permissionLoading = false;
    update();
  }

  /// Set permission info
  setPermissionInfo() async {
    sharedPreferences.setString(
        AppConstants.PERMISSION, json.encode(permissionModel));
    getPermissionInfo();
    update();
  }

  /// Get permission info
  getPermissionInfo() async {
    permissionModel = null;
    _appLogo = sharedPreferences.getString(AppConstants.APP_LOGO);
    final data =
        json.decode(sharedPreferences.getString(AppConstants.PERMISSION) ?? '');
    permissionModel = PermissionModel.fromJson(data);
    int count = 0;
    if (permissionModel!.createCustomers!) {
      count++;
    }
    if (permissionModel!.createProducts!) {
      count++;
    }
    if (permissionModel!.createExpenses!) {
      count++;
    }
    if (permissionModel!.createEstimates!) {
      count++;
    }
    if (permissionModel!.createInvoices!) {
      count++;
    }
    _createCount = count;
    update();
  }
}
