import 'dart:convert';


ContactUsModal contactUsModalFromJson(String str) => ContactUsModal.fromJson(json.decode(str));
String contactUsModalToJson(ContactUsModal data) => json.encode(data.toJson());
class ContactUsModal {
  ContactUsModal({
      bool? status, 
      String? message, 
      List<Contact>? contact,}){
    _status = status;
    _message = message;
    _contact = contact;
}

  ContactUsModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['contact'] != null) {
      _contact = [];
      json['contact'].forEach((v) {
        _contact?.add(Contact.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Contact>? _contact;
ContactUsModal copyWith({  bool? status,
  String? message,
  List<Contact>? contact,
}) => ContactUsModal(  status: status ?? _status,
  message: message ?? _message,
  contact: contact ?? _contact,
);
  bool? get status => _status;
  String? get message => _message;
  List<Contact>? get contact => _contact;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_contact != null) {
      map['contact'] = _contact?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));
String contactToJson(Contact data) => json.encode(data.toJson());
class Contact {
  Contact({
      String? id, 
      String? image, 
      String? link, 
      String? name, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _image = image;
    _link = link;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Contact.fromJson(dynamic json) {
    _id = json['_id'];
    _image = json['image'];
    _link = json['link'];
    _name = json['name'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _image;
  String? _link;
  String? _name;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Contact copyWith({  String? id,
  String? image,
  String? link,
  String? name,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Contact(  id: id ?? _id,
  image: image ?? _image,
  link: link ?? _link,
  name: name ?? _name,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get image => _image;
  String? get link => _link;
  String? get name => _name;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['image'] = _image;
    map['link'] = _link;
    map['name'] = _name;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}