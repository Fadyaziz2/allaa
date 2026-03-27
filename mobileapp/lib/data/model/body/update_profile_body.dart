class UpdateProfileBody {
  late String firstName;
  late String lastName;
  late String email;
  late String phoneCountry;
  late String phone;
  late String gender;
  late String address;

  UpdateProfileBody(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneCountry,
      required this.phone,
      required this.gender,
      required this.address});

  UpdateProfileBody.fromJson(Map<String, String> json) {
    firstName = json['first_name']!;
    lastName = json['last_name']!;
    email = json['email']!;
    phoneCountry = json['phone_country']!;
    phone = json['phone_number']!;
    gender = json['gender']!;
    address = json['address']!;
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_country'] = phoneCountry;
    data['phone_number'] = phone;
    data['gender'] = gender;
    data['address'] = address;
    return data;
  }
}
