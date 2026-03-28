class ProductModel {
  int? id;
  String? name;
  String? sku;
  String? code;
  String? categoryName;
  String? price;
  dynamic currentQuantity;
  dynamic alertQuantity;
  String? lastPurchasePrice;
  bool? isLowStock;

  ProductModel({
    this.id,
    this.name,
    this.sku,
    this.code,
    this.categoryName,
    this.price,
    this.currentQuantity,
    this.alertQuantity,
    this.lastPurchasePrice,
    this.isLowStock,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'] ?? json['code'];
    code = json['code'] ?? sku;
    categoryName = json['category_name'];
    price = json['price'];
    currentQuantity = json['current_quantity'];
    alertQuantity = json['alert_quantity'];
    lastPurchasePrice = json['last_purchase_price'];
    isLowStock = json['is_low_stock'] == true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sku'] = sku;
    data['code'] = code ?? sku;
    data['category_name'] = categoryName;
    data['price'] = price;
    data['current_quantity'] = currentQuantity;
    data['alert_quantity'] = alertQuantity;
    data['last_purchase_price'] = lastPurchasePrice;
    data['is_low_stock'] = isLowStock;
    return data;
  }
}
