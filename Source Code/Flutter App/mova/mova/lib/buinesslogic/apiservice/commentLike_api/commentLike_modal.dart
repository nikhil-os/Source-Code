class CommentLikeModal {
  CommentLikeModal({
      bool? status, 
      String? message, 
      bool? isLike,}){
    _status = status;
    _message = message;
    _isLike = isLike;
}

  CommentLikeModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _isLike = json['isLike'];
  }
  bool? _status;
  String? _message;
  bool? _isLike;
CommentLikeModal copyWith({  bool? status,
  String? message,
  bool? isLike,
}) => CommentLikeModal(  status: status ?? _status,
  message: message ?? _message,
  isLike: isLike ?? _isLike,
);
  bool? get status => _status;
  String? get message => _message;
  bool? get isLike => _isLike;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['isLike'] = _isLike;
    return map;
  }

}