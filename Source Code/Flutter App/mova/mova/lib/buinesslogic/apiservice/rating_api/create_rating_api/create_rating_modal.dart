import 'dart:convert';


CreateRatingModal createRatingModalFromJson(String str) => CreateRatingModal.fromJson(json.decode(str));
String createRatingModalToJson(CreateRatingModal data) => json.encode(data.toJson());
class CreateRatingModal {
  CreateRatingModal({
      bool? status, 
      String? message, 
      Rating? rating,}){
    _status = status;
    _message = message;
    _rating = rating;
}

  CreateRatingModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }
  bool? _status;
  String? _message;
  Rating? _rating;
CreateRatingModal copyWith({  bool? status,
  String? message,
  Rating? rating,
}) => CreateRatingModal(  status: status ?? _status,
  message: message ?? _message,
  rating: rating ?? _rating,
);
  bool? get status => _status;
  String? get message => _message;
  Rating? get rating => _rating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_rating != null) {
      map['rating'] = _rating?.toJson();
    }
    return map;
  }

}



Rating ratingFromJson(String str) => Rating.fromJson(json.decode(str));
String ratingToJson(Rating data) => json.encode(data.toJson());
class Rating {
  Rating({
      num? rating, 
      String? id, 
      String? userId, 
      String? movieId, 
      num? v,}){
    _rating = rating;
    _id = id;
    _userId = userId;
    _movieId = movieId;
    _v = v;
}

  Rating.fromJson(dynamic json) {
    _rating = json['rating'];
    _id = json['_id'];
    _userId = json['userId'];
    _movieId = json['movieId'];
    _v = json['__v'];
  }
  num? _rating;
  String? _id;
  String? _userId;
  String? _movieId;
  num? _v;
Rating copyWith({  num? rating,
  String? id,
  String? userId,
  String? movieId,
  num? v,
}) => Rating(  rating: rating ?? _rating,
  id: id ?? _id,
  userId: userId ?? _userId,
  movieId: movieId ?? _movieId,
  v: v ?? _v,
);
  num? get rating => _rating;
  String? get id => _id;
  String? get userId => _userId;
  String? get movieId => _movieId;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rating'] = _rating;
    map['_id'] = _id;
    map['userId'] = _userId;
    map['movieId'] = _movieId;
    map['__v'] = _v;
    return map;
  }

}