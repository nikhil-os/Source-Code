import 'dart:convert';
/// status : true
/// message : "Success!!"
/// favorite : [{"_id":"63d2465d8793395adbea4d07","userId":"63cb6e3dca7dc36bfdb85f33","movieId":"63d21c7d724b242e35cdfa8e","isPlan":false,"rating":[],"movie":[{"_id":"63d21c7d724b242e35cdfa8e","type":"default","media_type":"movie","title":"Gangubai Kathiawadi","year":"2022-02-24","image":"https://www.themoviedb.org/t/p/original/49czdTl4eA6YHrE7hqKUvzgWi5W.jpg","thumbnail":"https://www.themoviedb.org/t/p/original/wHPEKlzg7CaJFCjWlMdZKpCRIDl.jpg","genre":"Crime","region":"India"},{"_id":"63d21c7d724b242e35cdfa8e","type":"default","media_type":"movie","title":"Gangubai Kathiawadi","year":"2022-02-24","image":"https://www.themoviedb.org/t/p/original/49czdTl4eA6YHrE7hqKUvzgWi5W.jpg","thumbnail":"https://www.themoviedb.org/t/p/original/wHPEKlzg7CaJFCjWlMdZKpCRIDl.jpg","genre":"Drama","region":"India"}]}]

GetFavoriteListMovieModal getFavoriteListMovieModalFromJson(String str) => GetFavoriteListMovieModal.fromJson(json.decode(str));
String getFavoriteListMovieModalToJson(GetFavoriteListMovieModal data) => json.encode(data.toJson());
class GetFavoriteListMovieModal {
  GetFavoriteListMovieModal({
      bool? status, 
      String? message, 
      List<Favorite>? favorite,}){
    _status = status;
    _message = message;
    _favorite = favorite;
}

  GetFavoriteListMovieModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['favorite'] != null) {
      _favorite = [];
      json['favorite'].forEach((v) {
        _favorite?.add(Favorite.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Favorite>? _favorite;
GetFavoriteListMovieModal copyWith({  bool? status,
  String? message,
  List<Favorite>? favorite,
}) => GetFavoriteListMovieModal(  status: status ?? _status,
  message: message ?? _message,
  favorite: favorite ?? _favorite,
);
  bool? get status => _status;
  String? get message => _message;
  List<Favorite>? get favorite => _favorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_favorite != null) {
      map['favorite'] = _favorite?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}



Favorite favoriteFromJson(String str) => Favorite.fromJson(json.decode(str));
String favoriteToJson(Favorite data) => json.encode(data.toJson());
class Favorite {
  Favorite({
      String? id, 
      String? userId, 
      String? movieId, 
      bool? isPlan, 
      List<dynamic>? rating, 
      List<Movie>? movie,}){
    _id = id;
    _userId = userId;
    _movieId = movieId;
    _isPlan = isPlan;
    _rating = rating;
    _movie = movie;
}

  Favorite.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'];
    _movieId = json['movieId'];
    _isPlan = json['isPlan'];
    // if (json['rating'] != null) {
    //   _rating = [];
    //   json['rating'].forEach((v) {
    //     _rating?.add(Dynamic.fromJson(v));
    //   });
    // }
    if (json['movie'] != null) {
      _movie = [];
      json['movie'].forEach((v) {
        _movie?.add(Movie.fromJson(v));
      });
    }
  }
  String? _id;
  String? _userId;
  String? _movieId;
  bool? _isPlan;
  List<dynamic>? _rating;
  List<Movie>? _movie;
Favorite copyWith({  String? id,
  String? userId,
  String? movieId,
  bool? isPlan,
  List<dynamic>? rating,
  List<Movie>? movie,
}) => Favorite(  id: id ?? _id,
  userId: userId ?? _userId,
  movieId: movieId ?? _movieId,
  isPlan: isPlan ?? _isPlan,
  rating: rating ?? _rating,
  movie: movie ?? _movie,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get movieId => _movieId;
  bool? get isPlan => _isPlan;
  List<dynamic>? get rating => _rating;
  List<Movie>? get movie => _movie;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['userId'] = _userId;
    map['movieId'] = _movieId;
    map['isPlan'] = _isPlan;
    if (_rating != null) {
      map['rating'] = _rating?.map((v) => v.toJson()).toList();
    }
    if (_movie != null) {
      map['movie'] = _movie?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _id : "63d21c7d724b242e35cdfa8e"
/// type : "default"
/// media_type : "movie"
/// title : "Gangubai Kathiawadi"
/// year : "2022-02-24"
/// image : "https://www.themoviedb.org/t/p/original/49czdTl4eA6YHrE7hqKUvzgWi5W.jpg"
/// thumbnail : "https://www.themoviedb.org/t/p/original/wHPEKlzg7CaJFCjWlMdZKpCRIDl.jpg"
/// genre : "Crime"
/// region : "India"

Movie movieFromJson(String str) => Movie.fromJson(json.decode(str));
String movieToJson(Movie data) => json.encode(data.toJson());
class Movie {
  Movie({
      String? id, 
      String? type, 
      String? mediaType, 
      String? title, 
      String? year, 
      String? image, 
      String? thumbnail, 
      String? genre, 
      String? region,}){
    _id = id;
    _type = type;
    _mediaType = mediaType;
    _title = title;
    _year = year;
    _image = image;
    _thumbnail = thumbnail;
    _genre = genre;
    _region = region;
}

  Movie.fromJson(dynamic json) {
    _id = json['_id'];
    _type = json['type'];
    _mediaType = json['media_type'];
    _title = json['title'];
    _year = json['year'];
    _image = json['image'];
    _thumbnail = json['thumbnail'];
    _genre = json['genre'];
    _region = json['region'];
  }
  String? _id;
  String? _type;
  String? _mediaType;
  String? _title;
  String? _year;
  String? _image;
  String? _thumbnail;
  String? _genre;
  String? _region;
Movie copyWith({  String? id,
  String? type,
  String? mediaType,
  String? title,
  String? year,
  String? image,
  String? thumbnail,
  String? genre,
  String? region,
}) => Movie(  id: id ?? _id,
  type: type ?? _type,
  mediaType: mediaType ?? _mediaType,
  title: title ?? _title,
  year: year ?? _year,
  image: image ?? _image,
  thumbnail: thumbnail ?? _thumbnail,
  genre: genre ?? _genre,
  region: region ?? _region,
);
  String? get id => _id;
  String? get type => _type;
  String? get mediaType => _mediaType;
  String? get title => _title;
  String? get year => _year;
  String? get image => _image;
  String? get thumbnail => _thumbnail;
  String? get genre => _genre;
  String? get region => _region;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['type'] = _type;
    map['media_type'] = _mediaType;
    map['title'] = _title;
    map['year'] = _year;
    map['image'] = _image;
    map['thumbnail'] = _thumbnail;
    map['genre'] = _genre;
    map['region'] = _region;
    return map;
  }

}