class AddProductBody {
  late String productName;
  late String price;
  late String sku;
  late String code;
  late String categoryId;
  late String unitId;
  late String description;
  late String openingQuantity;
  late String alertQuantity;
  late String lastPurchasePrice;

  AddProductBody(
      {required this.productName,
      required this.price,
      required this.sku,
      required this.code,
      required this.categoryId,
      required this.unitId,
      required this.description,
      required this.openingQuantity,
      required this.alertQuantity,
      required this.lastPurchasePrice});

  AddProductBody.fromJson(Map<String, dynamic> json) {
    productName = json['name']?.toString() ?? '';
    price = json['price']?.toString() ?? '';
    sku = json['sku']?.toString() ?? json['code']?.toString() ?? '';
    code = json['code']?.toString() ?? sku;
    categoryId = json['category_id']?.toString() ?? '';
    unitId = json['unit_id']?.toString() ?? '';
    description = json['description']?.toString() ?? '';
    openingQuantity = json['opening_quantity']?.toString() ?? '0';
    alertQuantity = json['alert_quantity']?.toString() ?? '0';
    lastPurchasePrice = json['last_purchase_price']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = productName;
    data['price'] = price;
    data['sku'] = sku;
    data['code'] = code.isEmpty ? sku : code;
    data['category_id'] = categoryId;
    data['unit_id'] = unitId;
    data['description'] = description;
    data['opening_quantity'] = openingQuantity;
    data['alert_quantity'] = alertQuantity;
    data['last_purchase_price'] = lastPurchasePrice;
    return data;
  }
}
