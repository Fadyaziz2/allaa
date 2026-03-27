import 'package:invoicex/data/api/api_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/transaction_model.dart';
import '../data/repository/transaction_repo.dart';
import '../helper/date_converter.dart';

class TransactionController extends GetxController implements GetxService {
  final TransactionRepo transactionRepo;
  TransactionController({required this.transactionRepo});

  // Text editing controller
  final filterController = TextEditingController();

  int _paymentMethodIndex = 0;
  int? get paymentMethodIndex => _paymentMethodIndex;

  String? _dateRangeStartDate;
  String? get dateRangeStartDate => _dateRangeStartDate;

  String? _dateRangeEndDate;
  String? get dateRangeEndDate => _dateRangeEndDate;

  String? _addDate;
  String? get addDate => _addDate;

  List<TransactionModel> _transactionList = [];
  List<TransactionModel> get transactionList => _transactionList;

  bool _transactionListLoading = false;
  bool get transactionListLoading => _transactionListLoading;

  bool _transactionFilterLoading = false;
  bool get transactionFilterLoading => _transactionFilterLoading;

  bool _transactionPaginateLoading = false;
  bool get transactionPaginateLoading => _transactionPaginateLoading;

  String? _transactionNextPageUrl;
  String? get transactionNextPageUrl => _transactionNextPageUrl;

  String? _customerDropdownValue;
  String? get customerDropdownValue => _customerDropdownValue;

  String? _selectedCustomerIdValue;
  String? get selectedCustomerIdValue => _selectedCustomerIdValue;

  String? _filterStartDate;
  String? get filterStartDate => _filterStartDate;

  String? _filterStartDateValue;
  String? get filterStartDateValue => _filterStartDateValue;

  String? _filterEndDate;
  String? get filterEndDate => _filterEndDate;

  String? _filterEndDateValue;
  String? get filterEndDateValue => _filterEndDateValue;

  bool _isTransactionFilter = false;
  bool get isTransactionFilter => _isTransactionFilter;

  String? _paymentMethodDropdownValue;
  String? get paymentMethodDropdownValue => _paymentMethodDropdownValue;

  String? _paymentMethodDWBacUpValue;
  String? get paymentMethodDWBacUpValue => _paymentMethodDWBacUpValue;

  // Set payment method index
  void setPaymentMethodIndex(int index) {
    _paymentMethodIndex = index;
    update();
  }

  //  Date select
  Future<void> selectDate(BuildContext context, int contain) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final val = DateConverter.estimatedDate(picked);
      if (contain == 0) {
        _dateRangeStartDate = val;
      } else if (contain == 1) {
        _dateRangeEndDate = val;
      } else if (contain == 2) {
        _addDate = val;
      }
      update();
    }
  }

  // Get first two capital letters
  String getFirstTwoCapitalLetters(String input) {
    List<String> nameStringList = input.split(" ");

    String result = '';

    for (int i = 0; i < nameStringList.length; i++) {
      if (i == 0) {
        result += (nameStringList[i])[0].toUpperCase();
      } else if (i != 0 && i == nameStringList.length - 1) {
        result += (nameStringList[i])[0].toUpperCase();
      }
    }

    return result;
  }
  String beautifyText(String input) {
    return input
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
  // Get transaction data
  Future<ResponseModel> getTransaction(
      {bool isPaginate = false, bool fromFilter = false}) async {
    if (isPaginate) {
      _transactionPaginateLoading = true;
    } else {
      _transactionList = [];
      _transactionNextPageUrl = null;
      _transactionListLoading = true;
      _isTransactionFilter = fromFilter;
      if (!fromFilter) {
        refreshFilterForm();
      }
    }
    update();
    ResponseModel responseModel;
    if (fromFilter) {
      _transactionFilterLoading = true;
      update();
      _selectedCustomerIdValue =
          _customerDropdownValue != null ? _customerDropdownValue : null;
      _paymentMethodDWBacUpValue = _paymentMethodDropdownValue != null
          ? _paymentMethodDropdownValue
          : null;
      _filterStartDateValue = _filterStartDate;
      _filterEndDateValue = filterEndDate;
    }

    final response = await transactionRepo.getTransaction(
        url: transactionNextPageUrl,
        fromFilter: _isTransactionFilter,
        customerId: _selectedCustomerIdValue != null
            ? _selectedCustomerIdValue.toString()
            : "",
        paymentMethodId: _paymentMethodDWBacUpValue != null
            ? _paymentMethodDWBacUpValue.toString()
            : "",
        startDate: _filterStartDateValue ?? "",
        endDate: _filterEndDateValue ?? "");
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _transactionList.add(TransactionModel.fromJson(item));
      });
      _transactionNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    if (isPaginate) {
      _transactionPaginateLoading = false;
    } else {
      _transactionListLoading = false;
      _transactionFilterLoading = false;
    }

    update();
    return responseModel;
  }

  // Set payment method dw value
  setPaymentMethodDWValue(String? value) {
    _paymentMethodDropdownValue = value;
    update();
  }

  void refreshFilterForm() {
    _customerDropdownValue = null;
    _filterStartDate = null;
    _filterEndDate = null;
    _paymentMethodDropdownValue = null;
    filterController.text = '';
    update();
  }

  bool isEmptyFilterForm() {
    if (_customerDropdownValue == null &&
        _filterStartDate == null &&
        _filterEndDate == null &&
        _paymentMethodDropdownValue == null &&
        filterController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  setCustomerDropdownValue(String? value) {
    _customerDropdownValue = value;
    update();
  }

  void setFilterStartDate(String? date) {
    _filterStartDate = date;
    update();
  }

  void setFilterEndDate(String? date) {
    _filterEndDate = date;
    if (filterStartDate != null && filterEndDate != null) {
      filterController.text = "${filterStartDate}  To  ${filterEndDate}";
    }
    update();
  }
}
