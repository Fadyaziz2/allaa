import 'package:get/get.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class ReportRepo {
  // Local variable
  final ApiClient apiClient;

  // Repo start
  ReportRepo({required this.apiClient});

  // Get Income Report data
  Future<Response> getIncomeReport(
      {String? url,
      required bool fromFilter,
      String? startDate,
      String? endDate}) async {
    return await apiClient.getData(
        fromFilter
            ? url != null
                ? "$url&${"&issue_date[]=$startDate&issue_date[]=$endDate"}"
                : "${AppConstants.GET_INCOME_REPORT_URI}?${"&issue_date[]=$startDate&issue_date[]=$endDate"}"
            : url ?? AppConstants.GET_INCOME_REPORT_URI,
        isPaginate: url != null ? true : false);
  }

  // Get expenses report response
  Future<Response> getExpensesReport(
      {String? url,
      required bool fromFilter,
      String? startDate,
      String? endDate}) async {
    return await apiClient.getData(
        fromFilter
            ? url != null
                ? "$url&date[]=$startDate&date[]=$endDate"
                : "${AppConstants.GET_EXPENSES_REPORT_URI}?date[]=$startDate&date[]=$endDate"
            : url ?? AppConstants.GET_EXPENSES_REPORT_URI,
        isPaginate: url != null ? true : false);
  }
}
