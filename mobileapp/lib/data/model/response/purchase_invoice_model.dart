class PurchaseInvoiceModel {
  int? id;
  int? supplierId;
  String? supplierName;
  String? invoiceNumber;
  String? invoiceDate;
  double? total;
  double? paidAmount;
  double? dueAmount;
  int? itemsCount;

  PurchaseInvoiceModel({
    this.id,
    this.supplierId,
    this.supplierName,
    this.invoiceNumber,
    this.invoiceDate,
    this.total,
    this.paidAmount,
    this.dueAmount,
    this.itemsCount,
  });

  PurchaseInvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplier_id'];
    supplierName = json['supplier'] != null ? json['supplier']['name']?.toString() : null;
    invoiceNumber = json['invoice_number']?.toString();
    invoiceDate = json['invoice_date']?.toString();
    total = (json['total'] as num?)?.toDouble();
    paidAmount = (json['paid_amount'] as num?)?.toDouble();
    dueAmount = (json['due_amount'] as num?)?.toDouble();
    itemsCount = json['items_count'];
  }
}
