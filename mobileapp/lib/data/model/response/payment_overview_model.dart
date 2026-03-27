class PaymentOverviewModel {
  bool? status;
  String? message;
  List<Result>? result;

  PaymentOverviewModel({this.status, this.message, this.result});

  PaymentOverviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? name;
  dynamic amount;
  String? currencyWithAmount;

  Result({this.name, this.amount, this.currencyWithAmount});

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    currencyWithAmount = json['currency_with_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    data['currency_with_amount'] = currencyWithAmount;
    return data;
  }
}
