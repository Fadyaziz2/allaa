class EstimateModel {
  int? id;
  String? customerName;
  String? invoiceFullNumber;
  String? date;
  String? total;
  Status? status;

  EstimateModel(
      {this.id,
      this.customerName,
      this.invoiceFullNumber,
      this.date,
      this.total,
      this.status});

  EstimateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    invoiceFullNumber = json['invoice_full_number'];
    date = json['date'];
    total = json['total'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_name'] = customerName;
    data['invoice_full_number'] = invoiceFullNumber;
    data['date'] = date;
    data['total'] = total;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class Status {
  String? name;
  String? classType;

  Status({this.name, this.classType});

  Status.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    classType = json['class-type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['class-type'] = classType;
    return data;
  }
}
