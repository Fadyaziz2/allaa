class SupplierModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? contactPerson;
  double? totalPurchased;
  double? totalPaid;
  double? totalDue;

  SupplierModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.contactPerson,
    this.totalPurchased,
    this.totalPaid,
    this.totalDue,
  });

  SupplierModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']?.toString();
    email = json['email']?.toString();
    phone = json['phone']?.toString();
    address = json['address']?.toString();
    contactPerson = json['contact_person']?.toString();
    totalPurchased = (json['total_purchased'] as num?)?.toDouble();
    totalPaid = (json['total_paid'] as num?)?.toDouble();
    totalDue = (json['total_due'] as num?)?.toDouble();
  }
}
