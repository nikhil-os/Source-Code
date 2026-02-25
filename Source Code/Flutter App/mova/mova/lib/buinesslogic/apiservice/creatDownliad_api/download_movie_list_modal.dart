import 'dart:convert';

/// status : true
/// message : "Successful!!"
/// download : [{"_id":"63ddecd59b160fab02324429","userId":"63ce8560d15c8a5d4441a91b","createdAt":"2023-02-04T05:27:49.794Z","data":{"_id":"63d4fb8b3b0ed94a47a1a533","episodeNumber":5,"image":"https://www.themoviedb.org/t/p/original/7k2lJW59leHtyQpTdvHcAomxwZ7.jpg","link":"https://work8.digicean.com/","episodeName":"An Ominous Turn","media_type":"tv","title":"Tanaav","region":"India"}}]

DownloadMovieListModal downloadMovieListModalFromJson(String str) => DownloadMovieListModal.fromJson(json.decode(str));
String downloadMovieListModalToJson(DownloadMovieListModal data) => json.encode(data.toJson());

class DownloadMovieListModal {
  DownloadMovieListModal({
    bool? status,
    String? message,
    List<Download>? download,
  }) {
    _status = status;
    _message = message;
    _download = download;
  }

  DownloadMovieListModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['download'] != null) {
      _download = [];
      json['download'].forEach((v) {
        _download?.add(Download.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Download>? _download;
  DownloadMovieListModal copyWith({
    bool? status,
    String? message,
    List<Download>? download,
  }) =>
      DownloadMovieListModal(
        status: status ?? _status,
        message: message ?? _message,
        download: download ?? _download,
      );
  bool? get status => _status;
  String? get message => _message;
  List<Download>? get download => _download;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_download != null) {
      map['download'] = _download?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// _id : "63ddecd59b160fab02324429"
/// userId : "63ce8560d15c8a5d4441a91b"
/// createdAt : "2023-02-04T05:27:49.794Z"
/// data : {"_id":"63d4fb8b3b0ed94a47a1a533","episodeNumber":5,"image":"https://www.themoviedb.org/t/p/original/7k2lJW59leHtyQpTdvHcAomxwZ7.jpg","link":"https://work8.digicean.com/","episodeName":"An Ominous Turn","media_type":"tv","title":"Tanaav","region":"India"}

Download downloadFromJson(String str) => Download.fromJson(json.decode(str));
String downloadToJson(Download data) => json.encode(data.toJson());

class Download {
  Download({
    String? id,
    String? userId,
    String? createdAt,
    Data? data,
  }) {
    _id = id;
    _userId = userId;
    _createdAt = createdAt;
    _data = data;
  }

  Download.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'];
    _createdAt = json['createdAt'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _id;
  String? _userId;
  String? _createdAt;
  Data? _data;
  Download copyWith({
    String? id,
    String? userId,
    String? createdAt,
    Data? data,
  }) =>
      Download(
        id: id ?? _id,
        userId: userId ?? _userId,
        createdAt: createdAt ?? _createdAt,
        data: data ?? _data,
      );
  String? get id => _id;
  String? get userId => _userId;
  String? get createdAt => _createdAt;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['userId'] = _userId;
    map['createdAt'] = _createdAt;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// _id : "63d4fb8b3b0ed94a47a1a533"
/// episodeNumber : 5
/// image : "https://www.themoviedb.org/t/p/original/7k2lJW59leHtyQpTdvHcAomxwZ7.jpg"
/// link : "https://work8.digicean.com/"
/// episodeName : "An Ominous Turn"
/// media_type : "tv"
/// title : "Tanaav"
/// region : "India"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? id,
    num? episodeNumber,
    String? image,
    String? link,
    String? episodeName,
    String? mediaType,
    String? title,
    String? region,
  }) {
    _id = id;
    _episodeNumber = episodeNumber;
    _image = image;
    _link = link;
    _episodeName = episodeName;
    _mediaType = mediaType;
    _title = title;
    _region = region;
  }

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _episodeNumber = json['episodeNumber'];
    _image = json['image'];
    _link = json['link'];
    _episodeName = json['episodeName'];
    _mediaType = json['media_type'];
    _title = json['title'];
    _region = json['region'];
  }
  String? _id;
  num? _episodeNumber;
  String? _image;
  String? _link;
  String? _episodeName;
  String? _mediaType;
  String? _title;
  String? _region;
  Data copyWith({
    String? id,
    num? episodeNumber,
    String? image,
    String? link,
    String? episodeName,
    String? mediaType,
    String? title,
    String? region,
  }) =>
      Data(
        id: id ?? _id,
        episodeNumber: episodeNumber ?? _episodeNumber,
        image: image ?? _image,
        link: link ?? _link,
        episodeName: episodeName ?? _episodeName,
        mediaType: mediaType ?? _mediaType,
        title: title ?? _title,
        region: region ?? _region,
      );
  String? get id => _id;
  num? get episodeNumber => _episodeNumber;
  String? get image => _image;
  String? get link => _link;
  String? get episodeName => _episodeName;
  String? get mediaType => _mediaType;
  String? get title => _title;
  String? get region => _region;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['episodeNumber'] = _episodeNumber;
    map['image'] = _image;
    map['link'] = _link;
    map['episodeName'] = _episodeName;
    map['media_type'] = _mediaType;
    map['title'] = _title;
    map['region'] = _region;
    return map;
  }
}
