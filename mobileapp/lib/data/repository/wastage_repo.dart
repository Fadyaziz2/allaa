import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class WastageRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  WastageRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getWastages({String? url, String? categoryId, String? productId}) async {
    final query = url != null
        ? '$url&category=${categoryId ?? ''}&product=${productId ?? ''}'
        : '${AppConstants.GET_WASTAGES_URI}?category=${categoryId ?? ''}&product=${productId ?? ''}';
    return apiClient.getData(query, isPaginate: url != null);
  }

  Future<Response> addWastage(Map<String, dynamic> body) async {
    return apiClient.postData(AppConstants.ADD_WASTAGES_URI, body);
  }

  Future<Response> getSelectableProducts() async {
    return apiClient.getData(AppConstants.GET_SUGGEST_PRODUCT_URI);
  }

  Future<Response> getCategories() async {
    return apiClient.getData('${AppConstants.GET_CATEGORIES_URI}?type=category');
  }
}
