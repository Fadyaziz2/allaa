class RoleDetailModel {
  int? id;
  String? name;
  List<Permissions>? permissions;

  RoleDetailModel({this.id, this.name, this.permissions});

  RoleDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Permissions {
  int? id;
  String? name;
  String? groupName;
  String? translatedName;
  Pivot? pivot;

  Permissions(
      {this.id, this.name, this.groupName, this.translatedName, this.pivot});

  Permissions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    groupName = json['group_name'];
    translatedName = json['translated_name'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['group_name'] = this.groupName;
    data['translated_name'] = this.translatedName;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  String? roleId;
  String? permissionId;

  Pivot({this.roleId, this.permissionId});

  Pivot.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    permissionId = json['permission_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_id'] = this.roleId;
    data['permission_id'] = this.permissionId;
    return data;
  }
}
