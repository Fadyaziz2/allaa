class ProductDetailsModel {
  int? id;
  String? name;
  dynamic price;
  String? sku;
  String? code;
  int? unitId;
  int? categoryId;
  String? description;
  dynamic openingQuantity;
  dynamic currentQuantity;
  dynamic alertQuantity;
  dynamic lastPurchasePrice;
  List<dynamic>? stockMovements;

  ProductDetailsModel(
      {this.id,
      this.name,
      this.price,
      this.sku,
      this.code,
      this.unitId,
      this.categoryId,
      this.description,
      this.openingQuantity,
      this.currentQuantity,
      this.alertQuantity,
      this.lastPurchasePrice,
      this.stockMovements});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    sku = json['sku'] ?? json['code'];
    code = json['code'] ?? sku;
    unitId = json['unit_id'];
    categoryId = json['category_id'];
    description = json['description'];
    openingQuantity = json['opening_quantity'];
    currentQuantity = json['current_quantity'];
    alertQuantity = json['alert_quantity'];
    lastPurchasePrice = json['last_purchase_price'];
    stockMovements = json['stock_movements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['sku'] = sku;
    data['code'] = code ?? sku;
    data['unit_id'] = unitId;
    data['category_id'] = categoryId;
    data['description'] = description;
    data['opening_quantity'] = openingQuantity;
    data['current_quantity'] = currentQuantity;
    data['alert_quantity'] = alertQuantity;
    data['last_purchase_price'] = lastPurchasePrice;
    data['stock_movements'] = stockMovements;
    return data;
  }
}
