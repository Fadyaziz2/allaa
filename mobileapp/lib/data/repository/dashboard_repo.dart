import 'package:invoicex/data/model/body/update_profile_body.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class DashboardRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  DashboardRepo({required this.apiClient, required this.sharedPreferences});

  // Get DashBoard Info method
  Future<Response> getDashBoardData() async {
    return await apiClient.getData(
      AppConstants.GET_DASHBOARD_INFO_URI,
    );
  }

  // Get Payment Overview method
  Future<Response> getPaymentOverviewData() async {
    return await apiClient.getData(
      AppConstants.GET_PAYMENT_OVERVIEW_URI,
    );
  }

  // Get Income Overview method
  Future<Response> getIncomeOverviewData(String id) async {
    return await apiClient.getData(
      "${AppConstants.GET_INCOME_OVERVIEW_URI}$id",
    );
  }

  // Get Profile details
  Future<Response> getProfileDetails() async {
    return await apiClient.getData(AppConstants.GET_PROFILE_URI);
  }

  // Update profile information
  Future<Response> updateProfile({
    required UpdateProfileBody updateProfileBody,
    required XFile? image,
  }) async {
    return await apiClient.postMultipartData(
        AppConstants.UPDATE_PROFILE_URI,
        updateProfileBody.toJson(),
        image != null ? [MultipartBody('profile_picture', image)] : []);
  }
}
