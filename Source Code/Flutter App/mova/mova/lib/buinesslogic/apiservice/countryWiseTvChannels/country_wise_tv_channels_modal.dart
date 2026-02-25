import 'dart:convert';

CountryWiseTvChannelsModal countryWiseTvChannelsModalFromJson(String str) => CountryWiseTvChannelsModal.fromJson(json.decode(str));
String countryWiseTvChannelsModalToJson(CountryWiseTvChannelsModal data) => json.encode(data.toJson());

class CountryWiseTvChannelsModal {
  CountryWiseTvChannelsModal({
    bool? status,
    String? message,
    List<StreamData>? streamData,
  }) {
    _status = status;
    _message = message;
    _streamData = streamData;
  }

  CountryWiseTvChannelsModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['streamData'] != null) {
      _streamData = [];
      json['streamData'].forEach((v) {
        _streamData?.add(StreamData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<StreamData>? _streamData;
  CountryWiseTvChannelsModal copyWith({
    bool? status,
    String? message,
    List<StreamData>? streamData,
  }) =>
      CountryWiseTvChannelsModal(
        status: status ?? _status,
        message: message ?? _message,
        streamData: streamData ?? _streamData,
      );
  bool? get status => _status;
  String? get message => _message;
  List<StreamData>? get streamData => _streamData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_streamData != null) {
      map['streamData'] = _streamData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

StreamData streamDataFromJson(String str) => StreamData.fromJson(json.decode(str));
String streamDataToJson(StreamData data) => json.encode(data.toJson());

class StreamData {
  StreamData({
    String? channelId,
    String? streamURL,
    String? channelName,
    String? channelLogo,
    String? countryCode,
  }) {
    _channelId = channelId;
    _streamURL = streamURL;
    _channelName = channelName;
    _channelLogo = channelLogo;
    _countryCode = countryCode;
  }

  StreamData.fromJson(dynamic json) {
    _channelId = json['channelId'];
    _streamURL = json['streamURL'];
    _channelName = json['channelName'];
    _channelLogo = json['channelLogo'];
    _countryCode = json['countryCode'];
  }
  String? _channelId;
  String? _streamURL;
  String? _channelName;
  String? _channelLogo;
  String? _countryCode;
  StreamData copyWith({
    String? channelId,
    String? streamURL,
    String? channelName,
    String? channelLogo,
    String? countryCode,
  }) =>
      StreamData(
        channelId: channelId ?? _channelId,
        streamURL: streamURL ?? _streamURL,
        channelName: channelName ?? _channelName,
        channelLogo: channelLogo ?? _channelLogo,
        countryCode: countryCode ?? _countryCode,
      );
  String? get channelId => _channelId;
  String? get streamURL => _streamURL;
  String? get channelName => _channelName;
  String? get channelLogo => _channelLogo;
  String? get countryCode => _countryCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['channelId'] = _channelId;
    map['streamURL'] = _streamURL;
    map['channelName'] = _channelName;
    map['channelLogo'] = _channelLogo;
    map['countryCode'] = _countryCode;
    return map;
  }
}
