import 'dart:convert';


GetRatingModal getRatingModalFromJson(String str) => GetRatingModal.fromJson(json.decode(str));
String getRatingModalToJson(GetRatingModal data) => json.encode(data.toJson());
class GetRatingModal {
  GetRatingModal({
      bool? status, 
      String? message, 
      List<TotalRating>? totalRating,}){
    _status = status;
    _message = message;
    _totalRating = totalRating;
}

  GetRatingModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['totalRating'] != null) {
      _totalRating = [];
      json['totalRating'].forEach((v) {
        _totalRating?.add(TotalRating.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<TotalRating>? _totalRating;
GetRatingModal copyWith({  bool? status,
  String? message,
  List<TotalRating>? totalRating,
}) => GetRatingModal(  status: status ?? _status,
  message: message ?? _message,
  totalRating: totalRating ?? _totalRating,
);
  bool? get status => _status;
  String? get message => _message;
  List<TotalRating>? get totalRating => _totalRating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_totalRating != null) {
      map['totalRating'] = _totalRating?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

TotalRating totalRatingFromJson(String str) => TotalRating.fromJson(json.decode(str));
String totalRatingToJson(TotalRating data) => json.encode(data.toJson());
class TotalRating {
  TotalRating({
      String? id, 
      num? totalUser, 
      num? avgRating,}){
    _id = id;
    _totalUser = totalUser;
    _avgRating = avgRating;
}

  TotalRating.fromJson(dynamic json) {
    _id = json['_id'];
    _totalUser = json['totalUser'];
    _avgRating = json['avgRating'];
  }
  String? _id;
  num? _totalUser;
  num? _avgRating;
TotalRating copyWith({  String? id,
  num? totalUser,
  num? avgRating,
}) => TotalRating(  id: id ?? _id,
  totalUser: totalUser ?? _totalUser,
  avgRating: avgRating ?? _avgRating,
);
  String? get id => _id;
  num? get totalUser => _totalUser;
  num? get avgRating => _avgRating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['totalUser'] = _totalUser;
    map['avgRating'] = _avgRating;
    return map;
  }

}