// To parse this JSON data, do
//
//     final fetchReelsModel = fetchReelsModelFromJson(jsonString);

import 'dart:convert';

FetchReelsModel fetchReelsModelFromJson(String str) => FetchReelsModel.fromJson(json.decode(str));

String fetchReelsModelToJson(FetchReelsModel data) => json.encode(data.toJson());

class FetchReelsModel {
  bool? status;
  String? message;
  List<Data>? data;

  FetchReelsModel({
    this.status,
    this.message,
    this.data,
  });

  factory FetchReelsModel.fromJson(Map<String, dynamic> json) => FetchReelsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Data {
  String? id;
  String? videoImage;
  String? videoUrl;
  int? shareCount;
  DateTime? createdAt;
  String? movieSeriesId;
  String? movieSeriesTitle;
  String? movieSeriesDes;
  List<String>? genre;
  bool? isLike;
  int? totalLikes;

  Data({
    this.id,
    this.videoImage,
    this.videoUrl,
    this.shareCount,
    this.createdAt,
    this.movieSeriesId,
    this.movieSeriesTitle,
    this.movieSeriesDes,
    this.genre,
    this.isLike,
    this.totalLikes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        videoImage: json["videoImage"],
        videoUrl: json["videoUrl"],
        shareCount: json["shareCount"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        movieSeriesId: json["movieSeriesId"],
        movieSeriesTitle: json["movieSeriesTitle"],
        movieSeriesDes: json["movieSeriesDes"],
        genre: json["genre"] == null ? [] : List<String>.from(json["genre"]!.map((x) => x)),
        isLike: json["isLike"],
        totalLikes: json["totalLikes"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "videoImage": videoImage,
        "videoUrl": videoUrl,
        "shareCount": shareCount,
        "createdAt": createdAt?.toIso8601String(),
        "movieSeriesId": movieSeriesId,
        "movieSeriesTitle": movieSeriesTitle,
        "movieSeriesDes": movieSeriesDes,
        "genre": genre == null ? [] : List<dynamic>.from(genre!.map((x) => x)),
        "isLike": isLike,
        "totalLikes": totalLikes,
      };
}
