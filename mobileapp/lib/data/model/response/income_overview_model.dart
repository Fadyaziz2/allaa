class IncomeOverviewModel {
  int? income;
  String? context;
  String? date;

  IncomeOverviewModel({this.income, this.context, this.date});

  IncomeOverviewModel.fromJson(Map<String, dynamic> json) {
    income = json['income'].runtimeType == int
        ? json['income']
        : json['income'].toInt();
    context = json['context'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['income'] = income;
    data['context'] = context;
    data['date'] = date;
    return data;
  }
}
