import 'dart:convert';

MoreLikeThisModal moreLikeThisModalFromJson(String str) => MoreLikeThisModal.fromJson(json.decode(str));
String moreLikeThisModalToJson(MoreLikeThisModal data) => json.encode(data.toJson());

class MoreLikeThisModal {
  MoreLikeThisModal({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) {
    _status = status;
    _message = message;
    _movie = movie;
  }

  MoreLikeThisModal.fromJson(dynamic json) {
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
  MoreLikeThisModal copyWith({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) =>
      MoreLikeThisModal(
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
    bool? isNewRelease,
    List<String>? genre,
    num? view,
    num? comment,
    num? videoType,
    String? link,
    String? region,
    String? mediaType,
    String? title,
    String? year,
    String? runtime,
    String? description,
    String? image,
    String? thumbnail,
    String? tmdbMovieId,
    String? iMDBid,
    String? createdAt,
    String? updatedAt,
    num? rating,
  }) {
    _id = id;
    _type = type;
    _isNewRelease = isNewRelease;
    _genre = genre;
    _view = view;
    _comment = comment;
    _videoType = videoType;
    _link = link;
    _region = region;
    _mediaType = mediaType;
    _title = title;
    _year = year;
    _runtime = runtime;
    _description = description;
    _image = image;
    _thumbnail = thumbnail;
    _tmdbMovieId = tmdbMovieId;
    _iMDBid = iMDBid;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _rating = rating;
  }

  Movie.fromJson(dynamic json) {
    _id = json['_id'];
    _type = json['type'];
    _isNewRelease = json['isNewRelease'];
    _genre = json['genre'] != null ? json['genre'].cast<String>() : [];
    _view = json['view'];
    _comment = json['comment'];
    _videoType = json['videoType'];
    _link = json['link'];
    _region = json['region'];
    _mediaType = json['media_type'];
    _title = json['title'];
    _year = json['year'];
    _runtime = json['runtime'];
    _description = json['description'];
    _image = json['image'];
    _thumbnail = json['thumbnail'];
    _tmdbMovieId = json['TmdbMovieId'];
    _iMDBid = json['IMDBid'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _rating = json['rating'];
  }
  String? _id;
  String? _type;
  bool? _isNewRelease;
  List<String>? _genre;
  num? _view;
  num? _comment;
  num? _videoType;
  String? _link;
  String? _region;
  String? _mediaType;
  String? _title;
  String? _year;
  String? _runtime;
  String? _description;
  String? _image;
  String? _thumbnail;
  String? _tmdbMovieId;
  String? _iMDBid;
  String? _createdAt;
  String? _updatedAt;
  num? _rating;
  Movie copyWith({
    String? id,
    String? type,
    bool? isNewRelease,
    List<String>? genre,
    num? view,
    num? comment,
    num? videoType,
    String? link,
    String? region,
    String? mediaType,
    String? title,
    String? year,
    String? runtime,
    String? description,
    String? image,
    String? thumbnail,
    String? tmdbMovieId,
    String? iMDBid,
    String? createdAt,
    String? updatedAt,
    num? rating,
  }) =>
      Movie(
        id: id ?? _id,
        type: type ?? _type,
        isNewRelease: isNewRelease ?? _isNewRelease,
        genre: genre ?? _genre,
        view: view ?? _view,
        comment: comment ?? _comment,
        videoType: videoType ?? _videoType,
        link: link ?? _link,
        region: region ?? _region,
        mediaType: mediaType ?? _mediaType,
        title: title ?? _title,
        year: year ?? _year,
        runtime: runtime ?? _runtime,
        description: description ?? _description,
        image: image ?? _image,
        thumbnail: thumbnail ?? _thumbnail,
        tmdbMovieId: tmdbMovieId ?? _tmdbMovieId,
        iMDBid: iMDBid ?? _iMDBid,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        rating: rating ?? _rating,
      );
  String? get id => _id;
  String? get type => _type;
  bool? get isNewRelease => _isNewRelease;
  List<String>? get genre => _genre;
  num? get view => _view;
  num? get comment => _comment;
  num? get videoType => _videoType;
  String? get link => _link;
  String? get region => _region;
  String? get mediaType => _mediaType;
  String? get title => _title;
  String? get year => _year;
  String? get runtime => _runtime;
  String? get description => _description;
  String? get image => _image;
  String? get thumbnail => _thumbnail;
  String? get tmdbMovieId => _tmdbMovieId;
  String? get iMDBid => _iMDBid;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get rating => _rating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['type'] = _type;
    map['isNewRelease'] = _isNewRelease;
    map['genre'] = _genre;
    map['view'] = _view;
    map['comment'] = _comment;
    map['videoType'] = _videoType;
    map['link'] = _link;
    map['region'] = _region;
    map['media_type'] = _mediaType;
    map['title'] = _title;
    map['year'] = _year;
    map['runtime'] = _runtime;
    map['description'] = _description;
    map['image'] = _image;
    map['thumbnail'] = _thumbnail;
    map['TmdbMovieId'] = _tmdbMovieId;
    map['IMDBid'] = _iMDBid;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['rating'] = _rating;
    return map;
  }
}
