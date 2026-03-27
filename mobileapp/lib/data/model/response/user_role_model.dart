class UserRolesModel {
  int? id;
  String? name;
  bool? isAdmin;
  bool? isDefault;

  UserRolesModel({this.id, this.name, this.isAdmin, this.isDefault});

  UserRolesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isAdmin = json['is_admin'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_admin'] = this.isAdmin;
    data['is_default'] = this.isDefault;
    return data;
  }
}
