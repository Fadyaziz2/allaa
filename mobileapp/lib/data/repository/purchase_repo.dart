import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class PurchaseRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  PurchaseRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getSuppliers({String? search}) async {
    return await apiClient.getData(
      "${AppConstants.GET_SUPPLIERS_URI}?search=${search ?? ''}&per_page=50",
    );
  }

  Future<Response> addSupplier(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.ADD_SUPPLIERS_URI, body);
  }

  Future<Response> updateSupplier(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.UPDATE_SUPPLIERS_URI}$id", body);
  }

  Future<Response> deleteSupplier(int id) async {
    return await apiClient.deleteData("${AppConstants.DELETE_SUPPLIERS_URI}$id");
  }

  Future<Response> getPurchaseInvoices({String? supplierId}) async {
    final supplierQuery = (supplierId != null && supplierId.isNotEmpty)
        ? "&supplier_id=$supplierId"
        : "";
    return await apiClient.getData(
      "${AppConstants.GET_PURCHASE_INVOICES_URI}?per_page=50$supplierQuery",
    );
  }

  Future<Response> addPurchaseInvoice(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.ADD_PURCHASE_INVOICES_URI, body);
  }

  Future<Response> updatePurchaseInvoice(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.UPDATE_PURCHASE_INVOICES_URI}$id", body);
  }

  Future<Response> deletePurchaseInvoice(int id) async {
    return await apiClient.deleteData("${AppConstants.DELETE_PURCHASE_INVOICES_URI}$id");
  }

  Future<Response> addPayment(int invoiceId, Map<String, dynamic> body) async {
    return await apiClient.postData(
      "${AppConstants.PURCHASE_INVOICE_PAYMENT_URI}$invoiceId/payment",
      body,
    );
  }

  Future<Response> getSelectedSuppliers() async {
    return await apiClient.getData('/selected/suppliers');
  }

  Future<Response> getSelectedProducts() async {
    return await apiClient.getData('/selected/products');
  }
}
