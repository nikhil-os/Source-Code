import 'dart:convert';

SearchMovieModal searchMovieModalFromJson(String str) => SearchMovieModal.fromJson(json.decode(str));

String searchMovieModalToJson(SearchMovieModal data) => json.encode(data.toJson());

class SearchMovieModal {
  SearchMovieModal({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) {
    _status = status;
    _message = message;
    _movie = movie;
  }

  SearchMovieModal.fromJson(dynamic json) {
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

  SearchMovieModal copyWith({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) =>
      SearchMovieModal(
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
    List<Genre>? genre,
    num? view,
    num? comment,
    num? videoType,
    String? link,
    Region? region,
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
    if (json['genre'] != null) {
      _genre = [];
      json['genre'].forEach((v) {
        _genre?.add(Genre.fromJson(v));
      });
    }
    _view = json['view'];
    _comment = json['comment'];
    _videoType = json['videoType'];
    _link = json['link'];
    _region = json['region'] != null ? Region.fromJson(json['region']) : null;
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
  List<Genre>? _genre;
  num? _view;
  num? _comment;
  num? _videoType;
  String? _link;
  Region? _region;
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
    List<Genre>? genre,
    num? view,
    num? comment,
    num? videoType,
    String? link,
    Region? region,
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

  List<Genre>? get genre => _genre;

  num? get view => _view;

  num? get comment => _comment;

  num? get videoType => _videoType;

  String? get link => _link;

  Region? get region => _region;

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
    if (_genre != null) {
      map['genre'] = _genre?.map((v) => v.toJson()).toList();
    }
    map['view'] = _view;
    map['comment'] = _comment;
    map['videoType'] = _videoType;
    map['link'] = _link;
    if (_region != null) {
      map['region'] = _region?.toJson();
    }
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

/// _id : "63cf84571e860809a2df4a7c"
/// name : "India"

Region regionFromJson(String str) => Region.fromJson(json.decode(str));

String regionToJson(Region data) => json.encode(data.toJson());

class Region {
  Region({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Region.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
  }

  String? _id;
  String? _name;

  Region copyWith({
    String? id,
    String? name,
  }) =>
      Region(
        id: id ?? _id,
        name: name ?? _name,
      );

  String? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// _id : "63d213f74cc85c8fc4ca7fce"
/// name : "Romance"

Genre genreFromJson(String str) => Genre.fromJson(json.decode(str));

String genreToJson(Genre data) => json.encode(data.toJson());

class Genre {
  Genre({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Genre.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
  }

  String? _id;
  String? _name;

  Genre copyWith({
    String? id,
    String? name,
  }) =>
      Genre(
        id: id ?? _id,
        name: name ?? _name,
      );

  String? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    return map;
  }
}
