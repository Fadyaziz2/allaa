class ProductDetailsModel {
  int? id;
  String? name;
  dynamic price;
  String? sku;
  String? code;
  int? unitId;
  int? categoryId;
  String? description;

  ProductDetailsModel(
      {this.id,
      this.name,
      this.price,
      this.sku,
      this.code,
      this.unitId,
      this.categoryId,
      this.description});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    sku = json['sku'] ?? json['code'];
    code = json['code'] ?? sku;
    unitId = json['unit_id'];
    categoryId = json['category_id'];
    description = json['description'];
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
    return data;
  }
}
