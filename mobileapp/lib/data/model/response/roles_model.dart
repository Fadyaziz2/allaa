class RolesModel {
  int? id;
  String? name;
  int? userCount;
  List<String>? userProfilePictures;

  RolesModel({this.id, this.name, this.userCount, this.userProfilePictures});

  RolesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userCount = json['user_count'];
    userProfilePictures = json['user_profile_pictures'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_count'] = this.userCount;
    data['user_profile_pictures'] = this.userProfilePictures;
    return data;
  }
}

