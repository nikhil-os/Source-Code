import 'dart:convert';
NotificationgetModal notificationgetModalFromJson(String str) => NotificationgetModal.fromJson(json.decode(str));
String notificationgetModalToJson(NotificationgetModal data) => json.encode(data.toJson());
class NotificationgetModal {
  NotificationgetModal({
      bool? status, 
      String? message, 
      List<Notification>? notification,}){
    _status = status;
    _message = message;
    _notification = notification;
}

  NotificationgetModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['notification'] != null) {
      _notification = [];
      json['notification'].forEach((v) {
        _notification?.add(Notification.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Notification>? _notification;
NotificationgetModal copyWith({  bool? status,
  String? message,
  List<Notification>? notification,
}) => NotificationgetModal(  status: status ?? _status,
  message: message ?? _message,
  notification: notification ?? _notification,
);
  bool? get status => _status;
  String? get message => _message;
  List<Notification>? get notification => _notification;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_notification != null) {
      map['notification'] = _notification?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));
String notificationToJson(Notification data) => json.encode(data.toJson());
class Notification {
  Notification({
      String? id, 
      String? userId,
      String? title,
      String? message,
      String? image, 
      String? date,}){
    _id = id;
    _userId = userId;
    _title = title;
    _message = message;
    _image = image;
    _date = date;
}

  Notification.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'];
    _title = json['title'];
    _message = json['message'];
    _image = json['image'];
    _date = json['date'];
  }
  String? _id;
  String? _userId;
  String? _title;
  String? _message;
  String? _image;
  String? _date;
Notification copyWith({  String? id,
  String? userId,
  String? title,
  String? message,
  String? image,
  String? date,
}) => Notification(  id: id ?? _id,
  userId: userId ?? _userId,
  title: title ?? _title,
  message: message ?? _message,
  image: image ?? _image,
  date: date ?? _date,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get title => _title;
  String? get message => _message;
  String? get image => _image;
  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['userId'] = _userId;
    map['title'] = _title;
    map['message'] = _message;
    map['image'] = _image;
    map['date'] = _date;
    return map;
  }

}