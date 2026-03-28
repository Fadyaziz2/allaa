class WastageModel {
  int? id;
  int? productId;
  String? productName;
  String? categoryName;
  double? quantity;
  String? movementDate;
  String? note;

  WastageModel({
    this.id,
    this.productId,
    this.productName,
    this.categoryName,
    this.quantity,
    this.movementDate,
    this.note,
  });

  WastageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    categoryName = json['category_name'];
    quantity = (json['quantity'] as num?)?.toDouble();
    movementDate = json['movement_date'];
    note = json['note'];
  }
}
