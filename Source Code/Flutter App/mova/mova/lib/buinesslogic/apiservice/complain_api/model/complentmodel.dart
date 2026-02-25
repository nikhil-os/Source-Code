// import 'dart:convert';
//
// ComplentModel complentModelFromJson(String str) => ComplentModel.fromJson(json.decode(str));
// String complentModelToJson(ComplentModel data) => json.encode(data.toJson());
//
// class ComplentModel {
//   ComplentModel({
//     bool? status,
//     String? message,
//     TicketByUser? ticketByUser,
//   }) {
//     _status = status;
//     _message = message;
//     _ticketByUser = ticketByUser;
//   }
//
//   ComplentModel.fromJson(dynamic json) {
//     _status = json['status'];
//     _message = json['message'];
//     _ticketByUser = json['ticketByUser'] != null ? TicketByUser.fromJson(json['ticketByUser']) : null;
//   }
//   bool? _status;
//   String? _message;
//   TicketByUser? _ticketByUser;
//   ComplentModel copyWith({
//     bool? status,
//     String? message,
//     TicketByUser? ticketByUser,
//   }) =>
//       ComplentModel(
//         status: status ?? _status,
//         message: message ?? _message,
//         ticketByUser: ticketByUser ?? _ticketByUser,
//       );
//   bool? get status => _status;
//   String? get message => _message;
//   TicketByUser? get ticketByUser => _ticketByUser;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['status'] = _status;
//     map['message'] = _message;
//     if (_ticketByUser != null) {
//       map['ticketByUser'] = _ticketByUser?.toJson();
//     }
//     return map;
//   }
// }
//
// TicketByUser ticketByUserFromJson(String str) => TicketByUser.fromJson(json.decode(str));
// String ticketByUserToJson(TicketByUser data) => json.encode(data.toJson());
//
// class TicketByUser {
//   TicketByUser({
//     String? userId,
//     String? contactNumber,
//     String? description,
//     String? image,
//     String? id,
//     String? status,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     _userId = userId;
//     _contactNumber = contactNumber;
//     _description = description;
//     _image = image;
//     _id = id;
//     _status = status;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }
//
//   TicketByUser.fromJson(dynamic json) {
//     _userId = json['userId'];
//     _contactNumber = json['contactNumber'];
//     _description = json['description'];
//     _image = json['image'];
//     _id = json['_id'];
//     _status = json['status'];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//   }
//   String? _userId;
//   String? _contactNumber;
//   String? _description;
//   String? _image;
//   String? _id;
//   String? _status;
//   String? _createdAt;
//   String? _updatedAt;
//   TicketByUser copyWith({
//     String? userId,
//     String? contactNumber,
//     String? description,
//     String? image,
//     String? id,
//     String? status,
//     String? createdAt,
//     String? updatedAt,
//   }) =>
//       TicketByUser(
//         userId: userId ?? _userId,
//         contactNumber: contactNumber ?? _contactNumber,
//         description: description ?? _description,
//         image: image ?? _image,
//         id: id ?? _id,
//         status: status ?? _status,
//         createdAt: createdAt ?? _createdAt,
//         updatedAt: updatedAt ?? _updatedAt,
//       );
//   String? get userId => _userId;
//   String? get contactNumber => _contactNumber;
//   String? get description => _description;
//   String? get image => _image;
//   String? get id => _id;
//   String? get status => _status;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['userId'] = _userId;
//     map['contactNumber'] = _contactNumber;
//     map['description'] = _description;
//     map['image'] = _image;
//     map['_id'] = _id;
//     map['status'] = _status;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     return map;
//   }
// }
