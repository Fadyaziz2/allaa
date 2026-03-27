import 'package:invoicex/controller/expenses_controller.dart';
import 'package:invoicex/data/model/response/expenses_report_model.dart';
import 'package:invoicex/data/model/response/income_report_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:invoicex/helper/date_converter.dart';
import '../data/api/api_checker.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/report_repo.dart';

class ReportController extends GetxController implements GetxService {
  final ReportRepo reportRepo;
  ReportController({required this.reportRepo});

  // Text editing controller
  final incomeReportFilterController = TextEditingController();

  bool _incomeReportPaginateLoading = false;
  bool get incomeReportPaginateLoading => _incomeReportPaginateLoading;

  bool _expensesReportPaginateLoading = false;
  bool get expensesReportPaginateLoading => _expensesReportPaginateLoading;

  List<IncomeReportModel> _incomeReportList = [];
  List<IncomeReportModel> get incomeReportList => _incomeReportList;

  List<ExpensesReportModel> _expensesReportList = [];
  List<ExpensesReportModel> get expensesReportList => _expensesReportList;

  String? _incomeReportNextPageUrl;
  String? get incomeReportNextPageUrl => _incomeReportNextPageUrl;

  String? _expensesReportNextPageUrl;
  String? get expensesReportNextPageUrl => _expensesReportNextPageUrl;

  bool _incomeReportListLoading = false;
  bool get incomeReportListLoading => _incomeReportListLoading;

  bool _expensesReportListLoading = false;
  bool get expensesReportListLoading => _expensesReportListLoading;

  bool _isIncomeReportFilter = false;
  bool get isIncomeReportFilter => _isIncomeReportFilter;

  bool _isExpensesReportFilter = false;
  bool get isExpensesReportFilter => _isExpensesReportFilter;

  bool _incomeReportFilterLoading = false;
  bool get incomeReportFilterLoading => _incomeReportFilterLoading;

  bool _expensesReportFilterLoading = false;
  bool get expensesReportFilterLoading => _expensesReportFilterLoading;

  String? _incomeFilterStartDate;
  String? get incomeFilterStartDate => _incomeFilterStartDate;

  String? _incomeFilterEndDate;
  String? get incomeFilterEndDate => _incomeFilterEndDate;

  // Get Income Report data
  Future<ResponseModel> getIncomeReport(
      {bool isPaginate = false, bool fromFilter = false}) async {
    if (isPaginate) {
      _incomeReportPaginateLoading = true;
    } else {
      _incomeReportList = [];
      _incomeReportNextPageUrl = null;
      _incomeReportListLoading = true;
      _isIncomeReportFilter = fromFilter;
      if (!fromFilter) {
        refreshIncomeReportFilterForm();
      }
    }
    update();
    ResponseModel responseModel;
    if (fromFilter) {
      _incomeReportFilterLoading = true;
      update();
    }

    final response = await reportRepo.getIncomeReport(
      url: incomeReportNextPageUrl,
      fromFilter: _isIncomeReportFilter,
      startDate:
          DateConverter.convertToDateTimeFormat(_incomeFilterStartDate ?? ""),
      endDate:
          DateConverter.convertToDateTimeFormat(_incomeFilterEndDate ?? ""),
    );

    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _incomeReportList.add(IncomeReportModel.fromJson(item));
      });
      _incomeReportNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    if (isPaginate) {
      _incomeReportPaginateLoading = false;
    } else {
      _incomeReportListLoading = false;
      _incomeReportFilterLoading = false;
    }

    update();
    return responseModel;
  }

  // Get Expenses Report data
  Future<ResponseModel> getExpensesReport(
      {bool isPaginate = false, bool fromFilter = false}) async {
    if (isPaginate) {
      _expensesReportPaginateLoading = true;
    } else {
      _expensesReportList = [];
      _expensesReportNextPageUrl = null;
      _expensesReportListLoading = true;
      _isExpensesReportFilter = fromFilter;
      if (!fromFilter) {
        Get.find<ExpensesController>().refreshFilterForm();
      }
    }
    update();
    ResponseModel responseModel;
    if (fromFilter) {
      _expensesReportFilterLoading = true;
      update();
    }

    final response = await reportRepo.getExpensesReport(
      url: _expensesReportNextPageUrl,
      fromFilter: _isExpensesReportFilter,
      startDate: DateConverter.convertToDateTimeFormat(
          Get.find<ExpensesController>().filterStartDate ?? ""),
      endDate: DateConverter.convertToDateTimeFormat(
          Get.find<ExpensesController>().filterEndDate ?? ""),
    );
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _expensesReportList.add(ExpensesReportModel.fromJson(item));
      });
      _expensesReportNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
      ApiChecker.checkApi(response);
    }
    if (isPaginate) {
      _expensesReportPaginateLoading = false;
    } else {
      _expensesReportListLoading = false;
      _expensesReportFilterLoading = false;
    }

    update();
    return responseModel;
  }

  // Set income report filter start date
  void setFilterStartDate(String? date) {
    _incomeFilterStartDate = date;
    update();
  }

  // Set income report filter end date
  void setFilterEndDate(String? date) {
    _incomeFilterEndDate = date;
    if (_incomeFilterStartDate != null && _incomeFilterEndDate != null) {
      incomeReportFilterController.text =
          "${_incomeFilterStartDate}  To  ${_incomeFilterEndDate}";
    }
    update();
  }

  // Refresh Income Report Filter from
  void refreshIncomeReportFilterForm() {
    _incomeFilterStartDate = null;
    _incomeFilterEndDate = null;
    incomeReportFilterController.text = '';
    update();
  }

  bool isEmptyFilterForm() {
    if (_incomeFilterStartDate == null &&
        _incomeFilterEndDate == null &&
        incomeReportFilterController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
