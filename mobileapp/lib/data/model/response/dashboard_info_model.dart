class DashboardInfoModel {
  bool? status;
  String? message;
  Result? result;

  DashboardInfoModel({this.status, this.message, this.result});

  DashboardInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? totalAmount;
  String? totalPaidAmount;
  String? totalDueAmount;
  int? totalCustomer;
  int? totalProduct;
  int? totalInvoice;
  int? totalPaidInvoice;
  int? totalDueInvoice;

  Result(
      {this.totalAmount,
      this.totalPaidAmount,
      this.totalDueAmount,
      this.totalCustomer,
      this.totalProduct,
      this.totalInvoice,
      this.totalPaidInvoice,
      this.totalDueInvoice});

  Result.fromJson(Map<String, dynamic> json) {
    totalAmount = json['total_amount'];
    totalPaidAmount = json['total_paid_amount'];
    totalDueAmount = json['total_due_amount'];
    totalCustomer = json['total_customer'];
    totalProduct = json['total_product'];
    totalInvoice = json['total_invoice'];
    totalPaidInvoice = json['total_paid_invoice'];
    totalDueInvoice = json['total_due_invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_amount'] = totalAmount;
    data['total_paid_amount'] = totalPaidAmount;
    data['total_due_amount'] = totalDueAmount;
    data['total_customer'] = totalCustomer;
    data['total_product'] = totalProduct;
    data['total_invoice'] = totalInvoice;
    data['total_paid_invoice'] = totalPaidInvoice;
    data['total_due_invoice'] = totalDueInvoice;
    return data;
  }
}
