import 'dart:convert';

GetYearModal getYearModalFromJson(String str) => GetYearModal.fromJson(json.decode(str));
String getYearModalToJson(GetYearModal data) => json.encode(data.toJson());

class GetYearModal {
  GetYearModal({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) {
    _status = status;
    _message = message;
    _movie = movie;
  }

  GetYearModal.fromJson(dynamic json) {
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
  GetYearModal copyWith({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) =>
      GetYearModal(
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
    String? year,
  }) {
    _id = id;
    _year = year;
  }

  Movie.fromJson(dynamic json) {
    _id = json['_id'];
    _year = json['year'];
  }
  String? _id;
  String? _year;
  Movie copyWith({
    String? id,
    String? year,
  }) =>
      Movie(
        id: id ?? _id,
        year: year ?? _year,
      );
  String? get id => _id;
  String? get year => _year;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['year'] = _year;
    return map;
  }
}
