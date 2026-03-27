class ProfileDetailsModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? phoneCountry;
  String? address;
  String? gender;
  String? dateOfBirth;
  String? profilePicture;

  ProfileDetailsModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.phoneCountry,
      this.address,
      this.gender,
      this.dateOfBirth,
      this.profilePicture});

  ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'] ?? "";
    phoneNumber = json['phone_number'];
    phoneCountry = json['phone_country'];
    address = json['address'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['phone_country'] = phoneCountry;
    data['address'] = address;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['profile_picture'] = profilePicture;
    return data;
  }
}
