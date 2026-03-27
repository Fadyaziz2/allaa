class TaxModel {
  int? id;
  String? name;
  dynamic rate;
  String? currencyWithRate;

  TaxModel({this.id, this.name, this.rate, this.currencyWithRate});

  TaxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rate = json['rate'];
    currencyWithRate = json['currency_with_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['rate'] = rate;
    data['currency_with_rate'] = currencyWithRate;
    return data;
  }
}
