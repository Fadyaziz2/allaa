class AddProductBody {
  late String productName;
  late String price;
  late String sku;
  late String code;
  late String categoryId;
  late String unitId;
  late String description;

  AddProductBody(
      {required this.productName,
      required this.price,
      required this.sku,
      required this.code,
      required this.categoryId,
      required this.unitId,
      required this.description});

  AddProductBody.fromJson(Map<String, dynamic> json) {
    productName = json['name']?.toString() ?? '';
    price = json['price']?.toString() ?? '';
    sku = json['sku']?.toString() ?? json['code']?.toString() ?? '';
    code = json['code']?.toString() ?? sku;
    categoryId = json['category_id']?.toString() ?? '';
    unitId = json['unit_id']?.toString() ?? '';
    description = json['description']?.toString() ?? '';
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
    return data;
  }
}
