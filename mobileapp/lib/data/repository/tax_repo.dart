import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class TaxRepo {
  // Local variable
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  // Repo start
  TaxRepo({required this.apiClient, required this.sharedPreferences});

  // Get Notes response
  Future<Response> getTax({String? url}) async {
    return await apiClient.getData(url ?? AppConstants.GET_TAX_URI,
        isPaginate: url != null ? true : false);
  }

  // Add Note response
  Future<Response> addTax(
      {required String taxName, required String taxRate}) async {
    return await apiClient.postData(
      AppConstants.ADD_TAX_URI,
      {'name': taxName, 'rate': taxRate},
    );
  }

  // Edit Note response
  Future<Response> editTax(
      {required int id,
      required String editTaxName,
      required String editTaxRate}) async {
    return await apiClient.putData(
      "${AppConstants.EDIT_TAX_URI}$id",
      {'name': editTaxName, 'rate': editTaxRate},
    );
  }

  // Delete expenses category response
  Future<Response> deleteTax({required int id}) async {
    return await apiClient.deleteData("${AppConstants.DELETE_TAX_URI}$id");
  }
}
