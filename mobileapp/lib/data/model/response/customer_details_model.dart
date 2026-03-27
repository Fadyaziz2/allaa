class CustomerDetailsModel {
  Customer? customer;
  String? totalAmount;
  String? totalPaidAmount;
  String? totalDueAmount;

  CustomerDetailsModel(
      {this.customer,
      this.totalAmount,
      this.totalPaidAmount,
      this.totalDueAmount});

  CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    totalAmount = json['total_amount'];
    totalPaidAmount = json['total_paid_amount'];
    totalDueAmount = json['total_due_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['total_amount'] = totalAmount;
    data['total_paid_amount'] = totalPaidAmount;
    data['total_due_amount'] = totalDueAmount;
    return data;
  }
}

class Customer {
  int? id;
  String? fullName;
  String? email;
  String? profilePicture;

  Customer({this.id, this.fullName, this.email, this.profilePicture});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    data['profile_picture'] = profilePicture;
    return data;
  }
}
