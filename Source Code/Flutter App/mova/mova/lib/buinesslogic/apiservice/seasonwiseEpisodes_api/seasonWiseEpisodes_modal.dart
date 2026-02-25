// ignore_for_file: file_names

import 'dart:convert';


SeasonWiseEpisodesModal seasonWiseEpisodesModalFromJson(String str) => SeasonWiseEpisodesModal.fromJson(json.decode(str));
String seasonWiseEpisodesModalToJson(SeasonWiseEpisodesModal data) => json.encode(data.toJson());
class SeasonWiseEpisodesModal {
  SeasonWiseEpisodesModal({
      bool? status, 
      String? message, 
      List<Episode>? episode,}){
    _status = status;
    _message = message;
    _episode = episode;
}

  SeasonWiseEpisodesModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['episode'] != null) {
      _episode = [];
      json['episode'].forEach((v) {
        _episode?.add(Episode.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Episode>? _episode;
SeasonWiseEpisodesModal copyWith({  bool? status,
  String? message,
  List<Episode>? episode,
}) => SeasonWiseEpisodesModal(  status: status ?? _status,
  message: message ?? _message,
  episode: episode ?? _episode,
);
  bool? get status => _status;
  String? get message => _message;
  List<Episode>? get episode => _episode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_episode != null) {
      map['episode'] = _episode?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


Episode episodeFromJson(String str) => Episode.fromJson(json.decode(str));
String episodeToJson(Episode data) => json.encode(data.toJson());
class Episode {
  Episode({
      String? id, 
      num? videoType, 
      String? videoUrl, 
      String? name, 
      num? episodeNumber, 
      String? image, 
      num? seasonNumber, 
      String? tmdbMovieId, 
      bool? isDownload, 
      String? movieId, 
      String? title,}){
    _id = id;
    _videoType = videoType;
    _videoUrl = videoUrl;
    _name = name;
    _episodeNumber = episodeNumber;
    _image = image;
    _seasonNumber = seasonNumber;
    _tmdbMovieId = tmdbMovieId;
    _isDownload = isDownload;
    _movieId = movieId;
    _title = title;
}

  Episode.fromJson(dynamic json) {
    _id = json['_id'];
    _videoType = json['videoType'];
    _videoUrl = json['videoUrl'];
    _name = json['name'];
    _episodeNumber = json['episodeNumber'];
    _image = json['image'];
    _seasonNumber = json['seasonNumber'];
    _tmdbMovieId = json['TmdbMovieId'];
    _isDownload = json['isDownload'];
    _movieId = json['movieId'];
    _title = json['title'];
  }
  String? _id;
  num? _videoType;
  String? _videoUrl;
  String? _name;
  num? _episodeNumber;
  String? _image;
  num? _seasonNumber;
  String? _tmdbMovieId;
  bool? _isDownload;
  String? _movieId;
  String? _title;
Episode copyWith({  String? id,
  num? videoType,
  String? videoUrl,
  String? name,
  num? episodeNumber,
  String? image,
  num? seasonNumber,
  String? tmdbMovieId,
  bool? isDownload,
  String? movieId,
  String? title,
}) => Episode(  id: id ?? _id,
  videoType: videoType ?? _videoType,
  videoUrl: videoUrl ?? _videoUrl,
  name: name ?? _name,
  episodeNumber: episodeNumber ?? _episodeNumber,
  image: image ?? _image,
  seasonNumber: seasonNumber ?? _seasonNumber,
  tmdbMovieId: tmdbMovieId ?? _tmdbMovieId,
  isDownload: isDownload ?? _isDownload,
  movieId: movieId ?? _movieId,
  title: title ?? _title,
);
  String? get id => _id;
  num? get videoType => _videoType;
  String? get videoUrl => _videoUrl;
  String? get name => _name;
  num? get episodeNumber => _episodeNumber;
  String? get image => _image;
  num? get seasonNumber => _seasonNumber;
  String? get tmdbMovieId => _tmdbMovieId;
  bool? get isDownload => _isDownload;
  String? get movieId => _movieId;
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['videoType'] = _videoType;
    map['videoUrl'] = _videoUrl;
    map['name'] = _name;
    map['episodeNumber'] = _episodeNumber;
    map['image'] = _image;
    map['seasonNumber'] = _seasonNumber;
    map['TmdbMovieId'] = _tmdbMovieId;
    map['isDownload'] = _isDownload;
    map['movieId'] = _movieId;
    map['title'] = _title;
    return map;
  }

}