class CustomerModel {
  int? id;
  String? fullName;
  String? email;
  Status? status;
  String? profilePictureUrl;

  CustomerModel(
      {this.id,
      this.fullName,
      this.email,
      this.status,
      this.profilePictureUrl});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    profilePictureUrl = json['profile_picture_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['profile_picture_url'] = profilePictureUrl;
    return data;
  }
}

class Status {
  String? name;
  String? classType;

  Status({this.name, this.classType});

  Status.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    classType = json['class-type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['class-type'] = classType;
    return data;
  }
}
