import 'dart:convert';
/// status : true
/// message : "Success!!"
/// history : {"_id":"6391a2bea4a079f028204321","userId":"6374c04ba17cb5e7889c7f0e","premiumPlanId":"6374d9077dc9ce96eb6cf49f","paymentGateway":"GooglePlay","date":"12/8/2022, 8:39:26 AM"}

PremiumPlancreateHistoryModal premiumPlancreateHistoryModalFromJson(String str) => PremiumPlancreateHistoryModal.fromJson(json.decode(str));
String premiumPlancreateHistoryModalToJson(PremiumPlancreateHistoryModal data) => json.encode(data.toJson());
class PremiumPlancreateHistoryModal {
  PremiumPlancreateHistoryModal({
      bool? status, 
      String? message, 
      History? history,}){
    _status = status;
    _message = message;
    _history = history;
}

  PremiumPlancreateHistoryModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _history = json['history'] != null ? History.fromJson(json['history']) : null;
  }
  bool? _status;
  String? _message;
  History? _history;
PremiumPlancreateHistoryModal copyWith({  bool? status,
  String? message,
  History? history,
}) => PremiumPlancreateHistoryModal(  status: status ?? _status,
  message: message ?? _message,
  history: history ?? _history,
);
  bool? get status => _status;
  String? get message => _message;
  History? get history => _history;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_history != null) {
      map['history'] = _history?.toJson();
    }
    return map;
  }

}

/// _id : "6391a2bea4a079f028204321"
/// userId : "6374c04ba17cb5e7889c7f0e"
/// premiumPlanId : "6374d9077dc9ce96eb6cf49f"
/// paymentGateway : "GooglePlay"
/// date : "12/8/2022, 8:39:26 AM"

History historyFromJson(String str) => History.fromJson(json.decode(str));
String historyToJson(History data) => json.encode(data.toJson());
class History {
  History({
      String? id, 
      String? userId, 
      String? premiumPlanId, 
      String? paymentGateway, 
      String? date,}){
    _id = id;
    _userId = userId;
    _premiumPlanId = premiumPlanId;
    _paymentGateway = paymentGateway;
    _date = date;
}

  History.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'];
    _premiumPlanId = json['premiumPlanId'];
    _paymentGateway = json['paymentGateway'];
    _date = json['date'];
  }
  String? _id;
  String? _userId;
  String? _premiumPlanId;
  String? _paymentGateway;
  String? _date;
History copyWith({  String? id,
  String? userId,
  String? premiumPlanId,
  String? paymentGateway,
  String? date,
}) => History(  id: id ?? _id,
  userId: userId ?? _userId,
  premiumPlanId: premiumPlanId ?? _premiumPlanId,
  paymentGateway: paymentGateway ?? _paymentGateway,
  date: date ?? _date,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get premiumPlanId => _premiumPlanId;
  String? get paymentGateway => _paymentGateway;
  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['userId'] = _userId;
    map['premiumPlanId'] = _premiumPlanId;
    map['paymentGateway'] = _paymentGateway;
    map['date'] = _date;
    return map;
  }

}