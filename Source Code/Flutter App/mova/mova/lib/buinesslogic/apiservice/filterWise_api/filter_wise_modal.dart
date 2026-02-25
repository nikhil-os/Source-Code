import 'dart:convert';

FilterWiseModal filterWiseModalFromJson(String str) => FilterWiseModal.fromJson(json.decode(str));
String filterWiseModalToJson(FilterWiseModal data) => json.encode(data.toJson());

class FilterWiseModal {
  FilterWiseModal({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) {
    _status = status;
    _message = message;
    _movie = movie;
  }

  FilterWiseModal.fromJson(dynamic json) {
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
  FilterWiseModal copyWith({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) =>
      FilterWiseModal(
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
    bool? isNewRelease,
    List<String>? genre,
    String? tmdbMovieId,
    String? iMDBid,
    String? region,
    String? mediaType,
    String? title,
    String? year,
    String? image,
    String? thumbnail,
    num? rating,
  }) {
    _id = id;
    _isNewRelease = isNewRelease;
    _genre = genre;
    _tmdbMovieId = tmdbMovieId;
    _iMDBid = iMDBid;
    _region = region;
    _mediaType = mediaType;
    _title = title;
    _year = year;
    _image = image;
    _thumbnail = thumbnail;
    _rating = rating;
  }

  Movie.fromJson(dynamic json) {
    _id = json['_id'];
    _isNewRelease = json['isNewRelease'];
    _genre = json['genre'] != null ? json['genre'].cast<String>() : [];
    _tmdbMovieId = json['TmdbMovieId'];
    _iMDBid = json['IMDBid'];
    _region = json['region'];
    _mediaType = json['media_type'];
    _title = json['title'];
    _year = json['year'];
    _image = json['image'];
    _thumbnail = json['thumbnail'];
    _rating = json['rating'];
  }
  String? _id;
  bool? _isNewRelease;
  List<String>? _genre;
  String? _tmdbMovieId;
  String? _iMDBid;
  String? _region;
  String? _mediaType;
  String? _title;
  String? _year;
  String? _image;
  String? _thumbnail;
  num? _rating;
  Movie copyWith({
    String? id,
    bool? isNewRelease,
    List<String>? genre,
    String? tmdbMovieId,
    String? iMDBid,
    String? region,
    String? mediaType,
    String? title,
    String? year,
    String? image,
    String? thumbnail,
    num? rating,
  }) =>
      Movie(
        id: id ?? _id,
        isNewRelease: isNewRelease ?? _isNewRelease,
        genre: genre ?? _genre,
        tmdbMovieId: tmdbMovieId ?? _tmdbMovieId,
        iMDBid: iMDBid ?? _iMDBid,
        region: region ?? _region,
        mediaType: mediaType ?? _mediaType,
        title: title ?? _title,
        year: year ?? _year,
        image: image ?? _image,
        thumbnail: thumbnail ?? _thumbnail,
        rating: rating ?? _rating,
      );
  String? get id => _id;
  bool? get isNewRelease => _isNewRelease;
  List<String>? get genre => _genre;
  String? get tmdbMovieId => _tmdbMovieId;
  String? get iMDBid => _iMDBid;
  String? get region => _region;
  String? get mediaType => _mediaType;
  String? get title => _title;
  String? get year => _year;
  String? get image => _image;
  String? get thumbnail => _thumbnail;
  num? get rating => _rating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['isNewRelease'] = _isNewRelease;
    map['genre'] = _genre;
    map['TmdbMovieId'] = _tmdbMovieId;
    map['IMDBid'] = _iMDBid;
    map['region'] = _region;
    map['media_type'] = _mediaType;
    map['title'] = _title;
    map['year'] = _year;
    map['image'] = _image;
    map['thumbnail'] = _thumbnail;
    map['rating'] = _rating;
    return map;
  }
}
