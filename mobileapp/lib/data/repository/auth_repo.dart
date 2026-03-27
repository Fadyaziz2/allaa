import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  // login method
  Future<Response> login(
      {required String email, required String password,dynamic deviceToken}) async {
    return await apiClient.postData(
        AppConstants.LOGIN_URI, {
      "email": email,
      "password": password,
      "device_token": deviceToken,
    });
  }

  // Save Access Token in Shared Pref
  Future<bool> saveTenantToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token, AppConstants.LANGUAGE_CODE);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  // Save email in shared pref
  Future<void> saveUserEmailAndPassword(String email, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_EMAIL, email);
    } catch (e) {
      rethrow;
    }
  }

  // Save keep me logged in value in shared pref
  Future<void> saveKeepMeLoggedIn(bool keepLoggedIn) async {
    try {
      await sharedPreferences.setBool(
          AppConstants.KEEP_ME_LOGGED_IN, keepLoggedIn);
    } catch (e) {
      rethrow;
    }
  }

  // Clear credentials from shared pref
  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstants.USER_EMAIL);
  }

  // Get user email from shared pref
  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.USER_EMAIL) ?? "";
  }

  // Get user Password from shared pref
  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  // Clear all Shared pref data
  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.KEEP_ME_LOGGED_IN);
    apiClient.token = null;
    apiClient.updateHeader("", AppConstants.languages[0].languageCode!);
    return true;
  }

  // Check user is logged in
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  // Check user keep me logged in
  bool isKeepMeLoggedIn() {
    return sharedPreferences.getBool(AppConstants.KEEP_ME_LOGGED_IN) ?? false;
  }

  // Generate OTP method
  Future<Response> generateOtp({required String email}) async {
    return await apiClient
        .postData(AppConstants.GENERATE_OTP_URI, {"email": email});
  }

  // OTP Verification method
  Future<Response> optVerification(
      {required String email, required String otp}) async {
    return await apiClient.postData(
        AppConstants.OTP_VERIFICATION_URI, {"email": email, "otp_number": otp});
  }

  // Reset password method
  Future<Response> resetPassword(
      {required String email,
        required String otp,
        required String password,
        required confirmPassword}) async {
    return await apiClient.postData(AppConstants.CHANGE_PASSWORD_URI, {
      "email": email,
      "otp_number": otp,
      "password": password,
      "password_confirmation": confirmPassword
    });
  }
}
