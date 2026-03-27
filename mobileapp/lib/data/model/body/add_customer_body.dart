class AddCustomerBody {
  late String firstName;
  late String lastName;
  late String email;
  late String phoneCountry;
  late String phone;
  late String taxNo;
  late String portalAccess;

  AddCustomerBody(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneCountry,
      required this.phone,
      required this.taxNo,
      required this.portalAccess});

  AddCustomerBody.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneCountry = json['phone_country'];
    phone = json['phone_number'];
    taxNo = json['tax_no'];
    portalAccess = json['portal_access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_country'] = phoneCountry;
    data['phone_number'] = phone;
    data['tax_no'] = taxNo;
    data['portal_access'] = portalAccess;
    return data;
  }
}
