// class UsersModel {
//   int? id;
//   String? name;
//   String? email;
//   String? statusClass;
//   String? status;
//   String? role;
//   String? profilePictures;
//
//   UsersModel({this.id, this.name, this.email, this.statusClass, this.status,this.role,this.profilePictures});
//
//   UsersModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['full_name'];
//     email = json['email'];
//     statusClass = json['status_class'];
//     status = json['status'];
//     role = json['role'];
//     profilePictures = json['profile_pictures'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['full_name'] = name;
//     data['email'] = email;
//     data['status_class'] = statusClass;
//     data['status'] = status;
//     data['role'] = role;
//     data['profile_pictures'] = profilePictures;
//     return data;
//   }
// }

class UsersModel {
  int? id;
  String? fullName;
  String? email;
  bool? isAdmin;
  String? statusClass;
  String? statusName;
  String? status;
  String? role;
  String? profilePictures;

  UsersModel(
      {this.id,
        this.fullName,
        this.email,
        this.isAdmin,
        this.statusClass,
        this.statusName,
        this.status,
        this.role,
        this.profilePictures});

  UsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    isAdmin = json['is_admin'];
    statusClass = json['status_class'];
    statusName = json['status_name'];
    status = json['status'];
    role = json['role'];
    profilePictures = json['profile_pictures'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['is_admin'] = this.isAdmin;
    data['status_class'] = this.statusClass;
    data['status_name'] = this.statusName;
    data['status'] = this.status;
    data['role'] = this.role;
    data['profile_pictures'] = this.profilePictures;
    return data;
  }
}
