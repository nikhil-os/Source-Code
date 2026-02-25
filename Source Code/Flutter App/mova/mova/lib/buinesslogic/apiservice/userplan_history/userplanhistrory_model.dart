import 'dart:convert';
UserplanhistroryModel userplanhistroryModelFromJson(String str) => UserplanhistroryModel.fromJson(json.decode(str));
String userplanhistroryModelToJson(UserplanhistroryModel data) => json.encode(data.toJson());
class UserplanhistroryModel {
  UserplanhistroryModel({
      bool? status, 
      String? message, 
      List<History>? history,}){
    _status = status;
    _message = message;
    _history = history;
}

  UserplanhistroryModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['history'] != null) {
      _history = [];
      json['history'].forEach((v) {
        _history?.add(History.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<History>? _history;
UserplanhistroryModel copyWith({  bool? status,
  String? message,
  List<History>? history,
}) => UserplanhistroryModel(  status: status ?? _status,
  message: message ?? _message,
  history: history ?? _history,
);
  bool? get status => _status;
  String? get message => _message;
  List<History>? get history => _history;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_history != null) {
      map['history'] = _history?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

History historyFromJson(String str) => History.fromJson(json.decode(str));
String historyToJson(History data) => json.encode(data.toJson());
class History {
  History({
      String? id, 
      String? userId, 
      String? premiumPlanId, 
      String? paymentGateway, 
      String? fullName, 
      String? nickName, 
      String? image, 
      String? planStartDate, 
      String? planEndDate, 
      int? dollar, 
      int? validity, 
      String? validityType, 
      List<String>? planBenefit,}){
    _id = id;
    _userId = userId;
    _premiumPlanId = premiumPlanId;
    _paymentGateway = paymentGateway;
    _fullName = fullName;
    _nickName = nickName;
    _image = image;
    _planStartDate = planStartDate;
    _planEndDate = planEndDate;
    _dollar = dollar;
    _validity = validity;
    _validityType = validityType;
    _planBenefit = planBenefit;
}

  History.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'];
    _premiumPlanId = json['premiumPlanId'];
    _paymentGateway = json['paymentGateway'];
    _fullName = json['fullName'];
    _nickName = json['nickName'];
    _image = json['image'];
    _planStartDate = json['planStartDate'];
    _planEndDate = json['planEndDate'];
    _dollar = json['dollar'];
    _validity = json['validity'];
    _validityType = json['validityType'];
    _planBenefit = json['planBenefit'] != null ? json['planBenefit'].cast<String>() : [];
  }
  String? _id;
  String? _userId;
  String? _premiumPlanId;
  String? _paymentGateway;
  String? _fullName;
  String? _nickName;
  String? _image;
  String? _planStartDate;
  String? _planEndDate;
  int? _dollar;
  int? _validity;
  String? _validityType;
  List<String>? _planBenefit;
History copyWith({  String? id,
  String? userId,
  String? premiumPlanId,
  String? paymentGateway,
  String? fullName,
  String? nickName,
  String? image,
  String? planStartDate,
  String? planEndDate,
  int? dollar,
  int? validity,
  String? validityType,
  List<String>? planBenefit,
}) => History(  id: id ?? _id,
  userId: userId ?? _userId,
  premiumPlanId: premiumPlanId ?? _premiumPlanId,
  paymentGateway: paymentGateway ?? _paymentGateway,
  fullName: fullName ?? _fullName,
  nickName: nickName ?? _nickName,
  image: image ?? _image,
  planStartDate: planStartDate ?? _planStartDate,
  planEndDate: planEndDate ?? _planEndDate,
  dollar: dollar ?? _dollar,
  validity: validity ?? _validity,
  validityType: validityType ?? _validityType,
  planBenefit: planBenefit ?? _planBenefit,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get premiumPlanId => _premiumPlanId;
  String? get paymentGateway => _paymentGateway;
  String? get fullName => _fullName;
  String? get nickName => _nickName;
  String? get image => _image;
  String? get planStartDate => _planStartDate;
  String? get planEndDate => _planEndDate;
  int? get dollar => _dollar;
  int? get validity => _validity;
  String? get validityType => _validityType;
  List<String>? get planBenefit => _planBenefit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['userId'] = _userId;
    map['premiumPlanId'] = _premiumPlanId;
    map['paymentGateway'] = _paymentGateway;
    map['fullName'] = _fullName;
    map['nickName'] = _nickName;
    map['image'] = _image;
    map['planStartDate'] = _planStartDate;
    map['planEndDate'] = _planEndDate;
    map['dollar'] = _dollar;
    map['validity'] = _validity;
    map['validityType'] = _validityType;
    map['planBenefit'] = _planBenefit;
    return map;
  }

}