class InvoiceModel {
  int? id;
  String? customerName;
  String? invoiceNumber;
  String? issueDate;
  String? dueDate;
  String? totalAmount;
  String? paidAmount;
  String? dueAmount;
  Status? status;

  InvoiceModel(
      {this.id,
      this.customerName,
      this.invoiceNumber,
      this.issueDate,
      this.dueDate,
      this.totalAmount,
      this.paidAmount,
      this.dueAmount,
      this.status});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    invoiceNumber = json['invoice_number'];
    issueDate = json['issue_date'];
    dueDate = json['due_date'];
    totalAmount = json['total_amount'];
    paidAmount = json['paid_amount'];
    dueAmount = json['due_amount'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_name'] = customerName;
    data['invoice_number'] = invoiceNumber;
    data['issue_date'] = issueDate;
    data['due_date'] = dueDate;
    data['total_amount'] = totalAmount;
    data['paid_amount'] = paidAmount;
    data['due_amount'] = dueAmount;
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
