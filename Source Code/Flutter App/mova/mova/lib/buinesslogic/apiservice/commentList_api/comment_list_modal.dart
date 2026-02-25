class CommentListModal {
  CommentListModal({
    bool? status,
    String? message,
    List<Comment>? comment,
  }) {
    _status = status;
    _message = message;
    _comment = comment;
  }

  CommentListModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['comment'] != null) {
      _comment = [];
      json['comment'].forEach((v) {
        _comment?.add(Comment.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Comment>? _comment;
  CommentListModal copyWith({
    bool? status,
    String? message,
    List<Comment>? comment,
  }) =>
      CommentListModal(
        status: status ?? _status,
        message: message ?? _message,
        comment: comment ?? _comment,
      );
  bool? get status => _status;
  String? get message => _message;
  List<Comment>? get comment => _comment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_comment != null) {
      map['comment'] = _comment?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Comment {
  Comment({
    String? id,
    num? like,
    String? comment,
    String? date,
    String? createdAt,
    String? userId,
    String? fullName,
    String? userImage,
    bool? isLike,
    String? time,
  }) {
    _id = id;
    _like = like;
    _comment = comment;
    _date = date;
    _createdAt = createdAt;
    _userId = userId;
    _fullName = fullName;
    _userImage = userImage;
    _isLike = isLike;
    _time = time;
  }

  Comment.fromJson(dynamic json) {
    _id = json['_id'];
    _like = json['like'];
    _comment = json['comment'];
    _date = json['date'];
    _createdAt = json['createdAt'];
    _userId = json['userId'];
    _fullName = json['fullName'];
    _userImage = json['userImage'];
    _isLike = json['isLike'];
    _time = json['time'];
  }
  String? _id;
  num? _like;
  String? _comment;
  String? _date;
  String? _createdAt;
  String? _userId;
  String? _fullName;
  String? _userImage;
  bool? _isLike;
  String? _time;
  Comment copyWith({
    String? id,
    num? like,
    String? comment,
    String? date,
    String? createdAt,
    String? userId,
    String? fullName,
    String? userImage,
    bool? isLike,
    String? time,
  }) =>
      Comment(
        id: id ?? _id,
        like: like ?? _like,
        comment: comment ?? _comment,
        date: date ?? _date,
        createdAt: createdAt ?? _createdAt,
        userId: userId ?? _userId,
        fullName: fullName ?? _fullName,
        userImage: userImage ?? _userImage,
        isLike: isLike ?? _isLike,
        time: time ?? _time,
      );
  String? get id => _id;
  num? get like => _like;
  String? get comment => _comment;
  String? get date => _date;
  String? get createdAt => _createdAt;
  String? get userId => _userId;
  String? get fullName => _fullName;
  String? get userImage => _userImage;
  bool? get isLike => _isLike;
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['like'] = _like;
    map['comment'] = _comment;
    map['date'] = _date;
    map['createdAt'] = _createdAt;
    map['userId'] = _userId;
    map['fullName'] = _fullName;
    map['userImage'] = _userImage;
    map['isLike'] = _isLike;
    map['time'] = _time;
    return map;
  }
}
