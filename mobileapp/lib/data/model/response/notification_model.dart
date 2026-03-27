class NotificationModel {
  String? id;
  String? message;
  String? readAt;

  NotificationModel({this.id, this.message, this.readAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    readAt = json['read_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['read_at'] = readAt;
    return data;
  }
}
