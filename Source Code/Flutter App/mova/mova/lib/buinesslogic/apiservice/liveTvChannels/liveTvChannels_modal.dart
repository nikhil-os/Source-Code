// ignore_for_file: file_names

import 'dart:convert';


LiveTvChannelsModal liveTvChannelsModalFromJson(String str) => LiveTvChannelsModal.fromJson(json.decode(str));
String liveTvChannelsModalToJson(LiveTvChannelsModal data) => json.encode(data.toJson());
class LiveTvChannelsModal {
  LiveTvChannelsModal({
      bool? status, 
      String? message, 
      List<Stream>? stream,}){
    _status = status;
    _message = message;
    _stream = stream;
}

  LiveTvChannelsModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['stream'] != null) {
      _stream = [];
      json['stream'].forEach((v) {
        _stream?.add(Stream.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Stream>? _stream;
LiveTvChannelsModal copyWith({  bool? status,
  String? message,
  List<Stream>? stream,
}) => LiveTvChannelsModal(  status: status ?? _status,
  message: message ?? _message,
  stream: stream ?? _stream,
);
  bool? get status => _status;
  String? get message => _message;
  List<Stream>? get stream => _stream;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_stream != null) {
      map['stream'] = _stream?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


Stream streamFromJson(String str) => Stream.fromJson(json.decode(str));
String streamToJson(Stream data) => json.encode(data.toJson());
class Stream {
  Stream({
      String? id, 
      String? streamURL, 
      String? channelId, 
      String? channelName, 
      String? country, 
      String? channelLogo, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _streamURL = streamURL;
    _channelId = channelId;
    _channelName = channelName;
    _country = country;
    _channelLogo = channelLogo;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Stream.fromJson(dynamic json) {
    _id = json['_id'];
    _streamURL = json['streamURL'];
    _channelId = json['channelId'];
    _channelName = json['channelName'];
    _country = json['country'];
    _channelLogo = json['channelLogo'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _streamURL;
  String? _channelId;
  String? _channelName;
  String? _country;
  String? _channelLogo;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Stream copyWith({  String? id,
  String? streamURL,
  String? channelId,
  String? channelName,
  String? country,
  String? channelLogo,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Stream(  id: id ?? _id,
  streamURL: streamURL ?? _streamURL,
  channelId: channelId ?? _channelId,
  channelName: channelName ?? _channelName,
  country: country ?? _country,
  channelLogo: channelLogo ?? _channelLogo,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get streamURL => _streamURL;
  String? get channelId => _channelId;
  String? get channelName => _channelName;
  String? get country => _country;
  String? get channelLogo => _channelLogo;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['streamURL'] = _streamURL;
    map['channelId'] = _channelId;
    map['channelName'] = _channelName;
    map['country'] = _country;
    map['channelLogo'] = _channelLogo;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}