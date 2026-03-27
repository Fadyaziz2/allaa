class CustomerUpdateDetailsModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? phoneCountry;
  String? taxNo;
  bool? portalAccess;

  CustomerUpdateDetailsModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.phoneCountry,
      this.taxNo,
      this.portalAccess});

  CustomerUpdateDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    phoneCountry = json['phone_country'];
    taxNo = json['tax_no'];
    portalAccess = json['portal_access'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['phone_country'] = phoneCountry;
    data['tax_no'] = taxNo;
    data['portal_access'] = portalAccess;
    return data;
  }
}
