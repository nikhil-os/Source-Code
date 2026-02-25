// import 'dart:convert';
//
// /// hello everyone
// TopRatedModal topRatedModalFromJson(String str) => TopRatedModal.fromJson(json.decode(str));
// String topRatedModalToJson(TopRatedModal data) => json.encode(data.toJson());
// class TopRatedModal {
//   TopRatedModal({
//       bool? status,
//       String? message,
//       List<Movie>? movie,}){
//     _status = status;
//     _message = message;
//     _movie = movie;
// }
//
//   TopRatedModal.fromJson(dynamic json) {
//     _status = json['status'];
//     _message = json['message'];
//     if (json['movie'] != null) {
//       _movie = [];
//       json['movie'].forEach((v) {
//         _movie?.add(Movie.fromJson(v));
//       });
//     }
//   }
//   bool? _status;
//   String? _message;
//   List<Movie>? _movie;
// TopRatedModal copyWith({  bool? status,
//   String? message,
//   List<Movie>? movie,
// }) => TopRatedModal(  status: status ?? _status,
//   message: message ?? _message,
//   movie: movie ?? _movie,
// );
//   bool? get status => _status;
//   String? get message => _message;
//   List<Movie>? get movie => _movie;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['status'] = _status;
//     map['message'] = _message;
//     if (_movie != null) {
//       map['movie'] = _movie?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
//
//
// Movie movieFromJson(String str) => Movie.fromJson(json.decode(str));
// String movieToJson(Movie data) => json.encode(data.toJson());
// class Movie {
//   Movie({
//       String? id,
//       String? type,
//       String? title,
//       String? image,
//       String? thumbnail,
//       String? mediaType,
//       num? ratingAverage,}){
//     _id = id;
//     _type = type;
//     _title = title;
//     _image = image;
//     _thumbnail = thumbnail;
//     _mediaType = mediaType;
//     _ratingAverage = ratingAverage;
// }
//
//   Movie.fromJson(dynamic json) {
//     _id = json['_id'];
//     _type = json['type'];
//     _title = json['title'];
//     _image = json['image'];
//     _thumbnail = json['thumbnail'];
//     _mediaType = json['media_type'];
//     _ratingAverage = json['ratingAverage'];
//   }
//   String? _id;
//   String? _type;
//   String? _title;
//   String? _image;
//   String? _thumbnail;
//   String? _mediaType;
//   num? _ratingAverage;
// Movie copyWith({  String? id,
//   String? type,
//   String? title,
//   String? image,
//   String? thumbnail,
//   String? mediaType,
//   num? ratingAverage,
// }) => Movie(  id: id ?? _id,
//   type: type ?? _type,
//   title: title ?? _title,
//   image: image ?? _image,
//   thumbnail: thumbnail ?? _thumbnail,
//   mediaType: mediaType ?? _mediaType,
//   ratingAverage: ratingAverage ?? _ratingAverage,
// );
//   String? get id => _id;
//   String? get type => _type;
//   String? get title => _title;
//   String? get image => _image;
//   String? get thumbnail => _thumbnail;
//   String? get mediaType => _mediaType;
//   num? get ratingAverage => _ratingAverage;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['_id'] = _id;
//     map['type'] = _type;
//     map['title'] = _title;
//     map['image'] = _image;
//     map['thumbnail'] = _thumbnail;
//     map['media_type'] = _mediaType;
//     map['ratingAverage'] = _ratingAverage;
//     return map;
//   }
//
// }

import 'dart:convert';

TopRatedModal topRatedModalFromJson(String str) => TopRatedModal.fromJson(json.decode(str));
String topRatedModalToJson(TopRatedModal data) => json.encode(data.toJson());

class TopRatedModal {
  TopRatedModal({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) {
    _status = status;
    _message = message;
    _movie = movie;
  }

  TopRatedModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['movie'] != null) {
      _movie = [];
      json['movie'].forEach((v) {
        _movie?.add(Movie.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Movie>? _movie;
  TopRatedModal copyWith({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) =>
      TopRatedModal(
        status: status ?? _status,
        message: message ?? _message,
        movie: movie ?? _movie,
      );
  bool? get status => _status;
  String? get message => _message;
  List<Movie>? get movie => _movie;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_movie != null) {
      map['movie'] = _movie?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Movie movieFromJson(String str) => Movie.fromJson(json.decode(str));
String movieToJson(Movie data) => json.encode(data.toJson());

class Movie {
  Movie({
    String? id,
    String? type,
    String? tmdbMovieId,
    String? iMDBid,
    String? link,
    String? mediaType,
    String? title,
    String? image,
    String? thumbnail,
    int? ratingAverage,
    num? rating,
  }) {
    _id = id;
    _type = type;
    _tmdbMovieId = tmdbMovieId;
    _iMDBid = iMDBid;
    _link = link;
    _mediaType = mediaType;
    _title = title;
    _image = image;
    _thumbnail = thumbnail;
    _ratingAverage = ratingAverage;
    _rating = rating;
  }

  Movie.fromJson(dynamic json) {
    _id = json['_id'];
    _type = json['type'];
    _tmdbMovieId = json['TmdbMovieId'];
    _iMDBid = json['IMDBid'];
    _link = json['link'];
    _mediaType = json['media_type'];
    _title = json['title'];
    _image = json['image'];
    _thumbnail = json['thumbnail'];
    _ratingAverage = json['ratingAverage'];
    _rating = json['rating'];
  }
  String? _id;
  String? _type;
  String? _tmdbMovieId;
  String? _iMDBid;
  String? _link;
  String? _mediaType;
  String? _title;
  String? _image;
  String? _thumbnail;
  int? _ratingAverage;
  num? _rating;
  Movie copyWith({
    String? id,
    String? type,
    String? tmdbMovieId,
    String? iMDBid,
    String? link,
    String? mediaType,
    String? title,
    String? image,
    String? thumbnail,
    int? ratingAverage,
    num? rating,
  }) =>
      Movie(
        id: id ?? _id,
        type: type ?? _type,
        tmdbMovieId: tmdbMovieId ?? _tmdbMovieId,
        iMDBid: iMDBid ?? _iMDBid,
        link: link ?? _link,
        mediaType: mediaType ?? _mediaType,
        title: title ?? _title,
        image: image ?? _image,
        thumbnail: thumbnail ?? _thumbnail,
        ratingAverage: ratingAverage ?? _ratingAverage,
        rating: rating ?? _rating,
      );
  String? get id => _id;
  String? get type => _type;
  String? get tmdbMovieId => _tmdbMovieId;
  String? get iMDBid => _iMDBid;
  String? get link => _link;
  String? get mediaType => _mediaType;
  String? get title => _title;
  String? get image => _image;
  String? get thumbnail => _thumbnail;
  int? get ratingAverage => _ratingAverage;
  num? get rating => _rating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['type'] = _type;
    map['TmdbMovieId'] = _tmdbMovieId;
    map['IMDBid'] = _iMDBid;
    map['link'] = _link;
    map['media_type'] = _mediaType;
    map['title'] = _title;
    map['image'] = _image;
    map['thumbnail'] = _thumbnail;
    map['ratingAverage'] = _ratingAverage;
    map['rating'] = _rating;
    return map;
  }
}
