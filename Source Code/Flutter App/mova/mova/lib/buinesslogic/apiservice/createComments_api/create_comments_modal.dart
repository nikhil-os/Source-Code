import 'dart:convert';

/// status : true
/// message : "success"
/// comment : {"like":0,"_id":"638ada8034e83961b48acc59","userId":"638894dfb54221673bd6f5ca","movieId":"634a588b123241e371fef335","comment":"dfhdfhfh","date":"12/3/2022, 5:11:28 AM","createdAt":"2022-12-03T05:11:28.375Z","updatedAt":"2022-12-03T05:11:28.375Z"}

CreateCommentsModal createCommentsModalFromJson(String str) => CreateCommentsModal.fromJson(json.decode(str));
String createCommentsModalToJson(CreateCommentsModal data) => json.encode(data.toJson());

class CreateCommentsModal {
  CreateCommentsModal({
    bool? status,
    String? message,
    Comment? comment,
  }) {
    _status = status;
    _message = message;
    _comment = comment;
  }

  CreateCommentsModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _comment = json['comment'] != null ? Comment.fromJson(json['comment']) : null;
  }
  bool? _status;
  String? _message;
  Comment? _comment;
  CreateCommentsModal copyWith({
    bool? status,
    String? message,
    Comment? comment,
  }) =>
      CreateCommentsModal(
        status: status ?? _status,
        message: message ?? _message,
        comment: comment ?? _comment,
      );
  bool? get status => _status;
  String? get message => _message;
  Comment? get comment => _comment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_comment != null) {
      map['comment'] = _comment?.toJson();
    }
    return map;
  }
}

/// like : 0
/// _id : "638ada8034e83961b48acc59"
/// userId : "638894dfb54221673bd6f5ca"
/// movieId : "634a588b123241e371fef335"
/// comment : "dfhdfhfh"
/// date : "12/3/2022, 5:11:28 AM"
/// createdAt : "2022-12-03T05:11:28.375Z"
/// updatedAt : "2022-12-03T05:11:28.375Z"

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));
String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    num? like,
    String? id,
    String? userId,
    String? movieId,
    String? comment,
    String? date,
    String? createdAt,
    String? updatedAt,
  }) {
    _like = like;
    _id = id;
    _userId = userId;
    _movieId = movieId;
    _comment = comment;
    _date = date;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Comment.fromJson(dynamic json) {
    _like = json['like'];
    _id = json['_id'];
    _userId = json['userId'];
    _movieId = json['movieId'];
    _comment = json['comment'];
    _date = json['date'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _like;
  String? _id;
  String? _userId;
  String? _movieId;
  String? _comment;
  String? _date;
  String? _createdAt;
  String? _updatedAt;
  Comment copyWith({
    num? like,
    String? id,
    String? userId,
    String? movieId,
    String? comment,
    String? date,
    String? createdAt,
    String? updatedAt,
  }) =>
      Comment(
        like: like ?? _like,
        id: id ?? _id,
        userId: userId ?? _userId,
        movieId: movieId ?? _movieId,
        comment: comment ?? _comment,
        date: date ?? _date,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get like => _like;
  String? get id => _id;
  String? get userId => _userId;
  String? get movieId => _movieId;
  String? get comment => _comment;
  String? get date => _date;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['like'] = _like;
    map['_id'] = _id;
    map['userId'] = _userId;
    map['movieId'] = _movieId;
    map['comment'] = _comment;
    map['date'] = _date;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
