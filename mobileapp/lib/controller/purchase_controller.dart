import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/data/api/api_checker.dart';
import 'package:invoicex/data/model/response/purchase_invoice_model.dart';
import 'package:invoicex/data/model/response/supplier_model.dart';
import 'package:invoicex/data/repository/purchase_repo.dart';
import 'package:invoicex/view/base/custom_snackbar.dart';

class PurchaseController extends GetxController implements GetxService {
  final PurchaseRepo purchaseRepo;

  PurchaseController({required this.purchaseRepo});

  bool _suppliersLoading = false;
  bool get suppliersLoading => _suppliersLoading;

  bool _purchaseLoading = false;
  bool get purchaseLoading => _purchaseLoading;

  bool _actionLoading = false;
  bool get actionLoading => _actionLoading;

  List<SupplierModel> _suppliers = [];
  List<SupplierModel> get suppliers => _suppliers;

  List<SupplierModel> _supplierOptions = [];
  List<SupplierModel> get supplierOptions => _supplierOptions;

  List<Map<String, dynamic>> _productOptions = [];
  List<Map<String, dynamic>> get productOptions => _productOptions;

  List<PurchaseInvoiceModel> _purchaseInvoices = [];
  List<PurchaseInvoiceModel> get purchaseInvoices => _purchaseInvoices;

  final supplierNameController = TextEditingController();
  final supplierEmailController = TextEditingController();
  final supplierPhoneController = TextEditingController();
  final supplierAddressController = TextEditingController();
  final supplierContactController = TextEditingController();

  final invoiceNumberController = TextEditingController();
  final invoiceDateController = TextEditingController(text: DateTime.now().toString().split(' ').first);
  final discountController = TextEditingController(text: '0');
  final taxController = TextEditingController(text: '0');
  final paidAmountController = TextEditingController(text: '0');
  final noteController = TextEditingController();
  final paymentAmountController = TextEditingController();
  final paymentDateController = TextEditingController(text: DateTime.now().toString().split(' ').first);

  int? selectedSupplierId;
  String? selectedSupplierFilterId;

  List<Map<String, TextEditingController>> invoiceItems = [];

  void resetSupplierForm({SupplierModel? model}) {
    supplierNameController.text = model?.name ?? '';
    supplierEmailController.text = model?.email ?? '';
    supplierPhoneController.text = model?.phone ?? '';
    supplierAddressController.text = model?.address ?? '';
    supplierContactController.text = model?.contactPerson ?? '';
  }

  void resetPurchaseForm({PurchaseInvoiceModel? model}) {
    invoiceNumberController.text = model?.invoiceNumber ?? '';
    invoiceDateController.text = model?.invoiceDate?.split('T').first ?? DateTime.now().toString().split(' ').first;
    discountController.text = '0';
    taxController.text = '0';
    paidAmountController.text = model?.paidAmount?.toString() ?? '0';
    noteController.text = '';
    selectedSupplierId = model?.supplierId;
    clearInvoiceItems();
    addInvoiceItem(shouldUpdate: false);
  }

  void addInvoiceItem({bool shouldUpdate = true}) {
    invoiceItems.add({
      'product_id': TextEditingController(),
      'product_name': TextEditingController(),
      'quantity': TextEditingController(text: '1'),
      'unit_price': TextEditingController(text: '0'),
    });
    if (shouldUpdate) {
      update();
    }
  }

  void removeInvoiceItem(int index) {
    if (invoiceItems.length == 1) return;
    invoiceItems.removeAt(index);
    update();
  }

  void clearInvoiceItems() {
    invoiceItems = [];
  }

  Future<void> getSuppliers({String? search}) async {
    _suppliersLoading = true;
    update();
    final response = await purchaseRepo.getSuppliers(search: search);
    if (response.statusCode == 200 && response.body['status'] == true) {
      _suppliers = [];
      for (final item in response.body['result']['data']) {
        _suppliers.add(SupplierModel.fromJson(item));
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _suppliersLoading = false;
    update();
  }

  Future<void> getSupplierOptions() async {
    final response = await purchaseRepo.getSelectedSuppliers();
    if (response.statusCode == 200) {
      _supplierOptions = [];
      final dynamic body = response.body;
      final List<dynamic> list = body is List
          ? body
          : (body is Map<String, dynamic> && body['result'] is List)
              ? (body['result'] as List<dynamic>)
              : (body is Map<String, dynamic> && body['result'] is Map<String, dynamic> && body['result']['data'] is List)
                  ? (body['result']['data'] as List<dynamic>)
                  : <dynamic>[];

      for (final item in list) {
        if (item is Map<String, dynamic>) {
          _supplierOptions.add(SupplierModel.fromJson(item));
        }
      }
    }
    update();
  }

  Future<void> getProductOptions() async {
    final response = await purchaseRepo.getSelectedProducts();
    if (response.statusCode == 200) {
      _productOptions = [];
      final dynamic body = response.body;
      final List<dynamic> list = body is List
          ? body
          : (body is Map<String, dynamic> && body['result'] is List)
              ? (body['result'] as List<dynamic>)
              : (body is Map<String, dynamic> && body['result'] is Map<String, dynamic> && body['result']['data'] is List)
                  ? (body['result']['data'] as List<dynamic>)
                  : <dynamic>[];

      for (final item in list) {
        if (item is! Map<String, dynamic>) continue;
        _productOptions.add({
          'id': item['id'],
          'name': item['name']?.toString() ?? '',
          'price': (item['price'] as num?)?.toDouble() ?? 0,
        });
      }
    }
    update();
  }

  Future<void> addSupplier({int? id}) async {
    _actionLoading = true;
    update();
    final body = {
      'name': supplierNameController.text.trim(),
      'email': supplierEmailController.text.trim(),
      'phone': supplierPhoneController.text.trim(),
      'address': supplierAddressController.text.trim(),
      'contact_person': supplierContactController.text.trim(),
    };

    final response = id == null
        ? await purchaseRepo.addSupplier(body)
        : await purchaseRepo.updateSupplier(id, body);

    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getSuppliers();
    } else {
      ApiChecker.checkApi(response);
    }

    _actionLoading = false;
    update();
  }

  Future<void> deleteSupplier(int id) async {
    _actionLoading = true;
    update();
    final response = await purchaseRepo.deleteSupplier(id);
    if (response.statusCode == 200 && response.body['status'] == true) {
      showCustomSnackBar(response.body['message'], isError: false);
      getSuppliers();
    } else {
      ApiChecker.checkApi(response);
    }
    _actionLoading = false;
    update();
  }

  Future<void> getPurchaseInvoices() async {
    _purchaseLoading = true;
    update();
    final response = await purchaseRepo.getPurchaseInvoices(
      supplierId: selectedSupplierFilterId,
    );
    if (response.statusCode == 200) {
      _purchaseInvoices = [];
      final dynamic body = response.body;
      final List<dynamic> list = body is Map<String, dynamic> && body['result'] is Map<String, dynamic> && body['result']['data'] is List
          ? (body['result']['data'] as List<dynamic>)
          : (body is Map<String, dynamic> && body['data'] is List)
              ? (body['data'] as List<dynamic>)
              : <dynamic>[];

      for (final item in list) {
        if (item is! Map<String, dynamic>) continue;
        _purchaseInvoices.add(PurchaseInvoiceModel.fromJson(item));
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _purchaseLoading = false;
    update();
  }

  Future<void> submitPurchaseInvoice({int? id}) async {
    if (selectedSupplierId == null) {
      showCustomSnackBar('please_select_supplier_key'.tr);
      return;
    }
    if (invoiceItems.isEmpty) {
      showCustomSnackBar('please_add_item_key'.tr);
      return;
    }

    final items = <Map<String, dynamic>>[];
    for (final item in invoiceItems) {
      final productId = int.tryParse(item['product_id']!.text);
      final qty = double.tryParse(item['quantity']!.text) ?? 0;
      final price = double.tryParse(item['unit_price']!.text) ?? 0;
      if (productId == null || qty <= 0) {
        showCustomSnackBar('invalid_items_key'.tr);
        return;
      }
      items.add({
        'product_id': productId,
        'quantity': qty,
        'unit_price': price,
      });
    }

    _actionLoading = true;
    update();

    final body = {
      'supplier_id': selectedSupplierId,
      'invoice_number': invoiceNumberController.text.trim(),
      'invoice_date': invoiceDateController.text.trim(),
      'discount': double.tryParse(discountController.text.trim()) ?? 0,
      'tax': double.tryParse(taxController.text.trim()) ?? 0,
      'paid_amount': double.tryParse(paidAmountController.text.trim()) ?? 0,
      'note': noteController.text.trim(),
      'items': items,
    };

    final response = id == null
        ? await purchaseRepo.addPurchaseInvoice(body)
        : await purchaseRepo.updatePurchaseInvoice(id, body);

    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getPurchaseInvoices();
    } else {
      ApiChecker.checkApi(response);
    }
    _actionLoading = false;
    update();
  }

  Future<void> deletePurchaseInvoice(int id) async {
    _actionLoading = true;
    update();
    final response = await purchaseRepo.deletePurchaseInvoice(id);
    if (response.statusCode == 200 && response.body['status'] == true) {
      showCustomSnackBar(response.body['message'], isError: false);
      getPurchaseInvoices();
    } else {
      ApiChecker.checkApi(response);
    }
    _actionLoading = false;
    update();
  }

  Future<void> payPurchaseDue(int id) async {
    final amount = double.tryParse(paymentAmountController.text.trim()) ?? 0;
    if (amount <= 0) {
      showCustomSnackBar('invalid_amount_key'.tr);
      return;
    }
    _actionLoading = true;
    update();
    final response = await purchaseRepo.addPayment(id, {
      'amount': amount,
      'payment_date': paymentDateController.text.trim(),
      'reference': 'Mobile App',
      'note': 'Purchase due payment',
    });

    if (response.statusCode == 200 && response.body['status'] == true) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getPurchaseInvoices();
    } else {
      ApiChecker.checkApi(response);
    }
    _actionLoading = false;
    update();
  }
}
