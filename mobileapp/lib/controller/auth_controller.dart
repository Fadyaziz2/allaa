import 'package:get/get.dart';
import 'package:invoicex/controller/permission_controller.dart';
import 'package:invoicex/data/model/response/permission_model.dart';

import '../data/model/response/response_model.dart';
import '../data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isGenerateOtpLoading = false;
  bool get isGenerateOtpLoading => _isGenerateOtpLoading;

  bool _isOtpVerificationLoading = false;
  bool get isOtpVerificationLoading => _isOtpVerificationLoading;

  bool _isResetPasswordLoading = false;
  bool get isResetPasswordLoading => _isResetPasswordLoading;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  // login Method
  Future<ResponseModel> login(
      {required String email,
      required String password,
      dynamic deviceToken}) async {
    _isLoading = true;
    update();
    if (isLoggedIn()) {
      clearSharedData();
    }

    Response response = await authRepo.login(
        email: email,
        password: password,
        deviceToken: deviceToken ?? "No Device Token");
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      print("device_token $deviceToken");
      print('object ${response.body}');
      print('object statusCode ${response.statusCode}');
      authRepo.saveTenantToken(response.body['result']['access_token']);
      Get.find<PermissionController>().permissionModel =
          PermissionModel.fromJson(response.body['result']['permissions']);
      Get.find<PermissionController>().setPermissionInfo();
      responseModel = ResponseModel(
        true,
        response.body['message'],
      );
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // Save email and Password in shared pref
  void saveUserNumberAndPassword(
      {required String email, required String password}) {
    authRepo.saveUserEmailAndPassword(email, password);
  }

  // Save keep me logged in value
  void saveKeepMeLoggedIn() {
    authRepo.saveKeepMeLoggedIn(isActiveRememberMe);
  }

  // Clear  credentials from shared pref
  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  // Keep me logged in button toggle
  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  // Get user email from shared pref
  String getUserEmail() {
    return authRepo.getUserEmail();
  }

  // Get user Password from shared pref
  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  // Clear all Shared pref data
  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  // Check user is logged in
  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  // Check user keep me logged in
  bool isKeepMeLoggedIn() {
    return authRepo.isKeepMeLoggedIn();
  }

  // Update verification code
  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  // generate OTP
  Future<ResponseModel> generateOtp({required String email}) async {
    _isGenerateOtpLoading = true;
    update();
    if (isLoggedIn()) {
      clearSharedData();
    }
    Response response = await authRepo.generateOtp(
      email: email,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      responseModel = ResponseModel(
        true,
        response.body['message'],
      );
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isGenerateOtpLoading = false;
    update();
    return responseModel;
  }

  // OTP Verification
  Future<ResponseModel> otpVerification({required String email}) async {
    _isOtpVerificationLoading = true;
    update();
    Response response =
        await authRepo.optVerification(email: email, otp: _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      responseModel = ResponseModel(
        true,
        response.body['message'],
      );
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isOtpVerificationLoading = false;
    update();
    return responseModel;
  }

  // Reset Password
  Future<ResponseModel> resetPassword(
      {required String email,
      required String password,
      required String confirmPassword}) async {
    _isResetPasswordLoading = true;
    update();
    Response response = await authRepo.resetPassword(
        email: email,
        otp: _verificationCode,
        password: password,
        confirmPassword: confirmPassword);
    ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      responseModel = ResponseModel(
        true,
        response.body['message'],
      );
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isResetPasswordLoading = false;
    update();
    return responseModel;
  }
}
