// ignore_for_file: file_names

import 'dart:convert';

WhoLoginModal whoLoginModalFromJson(String str) => WhoLoginModal.fromJson(json.decode(str));
String whoLoginModalToJson(WhoLoginModal data) => json.encode(data.toJson());
class WhoLoginModal {
  WhoLoginModal({
      bool? status, 
      String? message, 
      User? user,}){
    _status = status;
    _message = message;
    _user = user;
}

  WhoLoginModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  bool? _status;
  String? _message;
  User? _user;
WhoLoginModal copyWith({  bool? status,
  String? message,
  User? user,
}) => WhoLoginModal(  status: status ?? _status,
  message: message ?? _message,
  user: user ?? _user,
);
  bool? get status => _status;
  String? get message => _message;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}



User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      Notification? notification, 
      Plan? plan, 
      String? id, 
      String? image, 
      String? fullName, 
      String? nickName, 
      String? email, 
      String? gender, 
      String? country, 
      String? password, 
      String? uniqueId, 
      List<String>? interest, 
      bool? isBlock, 
      bool? isPremiumPlan, 
      String? referralCode, 
      String? date, 
      String? identity, 
      String? fcmToken, 
      String? createdAt, 
      String? updatedAt,}){
    _notification = notification;
    _plan = plan;
    _id = id;
    _image = image;
    _fullName = fullName;
    _nickName = nickName;
    _email = email;
    _gender = gender;
    _country = country;
    _password = password;
    _uniqueId = uniqueId;
    _interest = interest;
    _isBlock = isBlock;
    _isPremiumPlan = isPremiumPlan;
    _referralCode = referralCode;
    _date = date;
    _identity = identity;
    _fcmToken = fcmToken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  User.fromJson(dynamic json) {
    _notification = json['notification'] != null ? Notification.fromJson(json['notification']) : null;
    _plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    _id = json['_id'];
    _image = json['image'];
    _fullName = json['fullName'];
    _nickName = json['nickName'];
    _email = json['email'];
    _gender = json['gender'];
    _country = json['country'];
    _password = json['password'];
    _uniqueId = json['uniqueId'];
    _interest = json['interest'] != null ? json['interest'].cast<String>() : [];
    _isBlock = json['isBlock'];
    _isPremiumPlan = json['isPremiumPlan'];
    _referralCode = json['referralCode'];
    _date = json['date'];
    _identity = json['identity'];
    _fcmToken = json['fcmToken'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  Notification? _notification;
  Plan? _plan;
  String? _id;
  String? _image;
  String? _fullName;
  String? _nickName;
  String? _email;
  String? _gender;
  String? _country;
  String? _password;
  String? _uniqueId;
  List<String>? _interest;
  bool? _isBlock;
  bool? _isPremiumPlan;
  String? _referralCode;
  String? _date;
  String? _identity;
  String? _fcmToken;
  String? _createdAt;
  String? _updatedAt;
User copyWith({  Notification? notification,
  Plan? plan,
  String? id,
  String? image,
  String? fullName,
  String? nickName,
  String? email,
  String? gender,
  String? country,
  String? password,
  String? uniqueId,
  List<String>? interest,
  bool? isBlock,
  bool? isPremiumPlan,
  String? referralCode,
  String? date,
  String? identity,
  String? fcmToken,
  String? createdAt,
  String? updatedAt,
}) => User(  notification: notification ?? _notification,
  plan: plan ?? _plan,
  id: id ?? _id,
  image: image ?? _image,
  fullName: fullName ?? _fullName,
  nickName: nickName ?? _nickName,
  email: email ?? _email,
  gender: gender ?? _gender,
  country: country ?? _country,
  password: password ?? _password,
  uniqueId: uniqueId ?? _uniqueId,
  interest: interest ?? _interest,
  isBlock: isBlock ?? _isBlock,
  isPremiumPlan: isPremiumPlan ?? _isPremiumPlan,
  referralCode: referralCode ?? _referralCode,
  date: date ?? _date,
  identity: identity ?? _identity,
  fcmToken: fcmToken ?? _fcmToken,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  Notification? get notification => _notification;
  Plan? get plan => _plan;
  String? get id => _id;
  String? get image => _image;
  String? get fullName => _fullName;
  String? get nickName => _nickName;
  String? get email => _email;
  String? get gender => _gender;
  String? get country => _country;
  String? get password => _password;
  String? get uniqueId => _uniqueId;
  List<String>? get interest => _interest;
  bool? get isBlock => _isBlock;
  bool? get isPremiumPlan => _isPremiumPlan;
  String? get referralCode => _referralCode;
  String? get date => _date;
  String? get identity => _identity;
  String? get fcmToken => _fcmToken;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_notification != null) {
      map['notification'] = _notification?.toJson();
    }
    if (_plan != null) {
      map['plan'] = _plan?.toJson();
    }
    map['_id'] = _id;
    map['image'] = _image;
    map['fullName'] = _fullName;
    map['nickName'] = _nickName;
    map['email'] = _email;
    map['gender'] = _gender;
    map['country'] = _country;
    map['password'] = _password;
    map['uniqueId'] = _uniqueId;
    map['interest'] = _interest;
    map['isBlock'] = _isBlock;
    map['isPremiumPlan'] = _isPremiumPlan;
    map['referralCode'] = _referralCode;
    map['date'] = _date;
    map['identity'] = _identity;
    map['fcmToken'] = _fcmToken;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// planStartDate : "2/3/2023, 2:21:01 PM"
/// premiumPlanId : "6374db8a4dfaba297326ce1e"

Plan planFromJson(String str) => Plan.fromJson(json.decode(str));
String planToJson(Plan data) => json.encode(data.toJson());
class Plan {
  Plan({
      String? planStartDate, 
      String? premiumPlanId,}){
    _planStartDate = planStartDate;
    _premiumPlanId = premiumPlanId;
}

  Plan.fromJson(dynamic json) {
    _planStartDate = json['planStartDate'];
    _premiumPlanId = json['premiumPlanId'];
  }
  String? _planStartDate;
  String? _premiumPlanId;
Plan copyWith({  String? planStartDate,
  String? premiumPlanId,
}) => Plan(  planStartDate: planStartDate ?? _planStartDate,
  premiumPlanId: premiumPlanId ?? _premiumPlanId,
);
  String? get planStartDate => _planStartDate;
  String? get premiumPlanId => _premiumPlanId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['planStartDate'] = _planStartDate;
    map['premiumPlanId'] = _premiumPlanId;
    return map;
  }

}

/// GeneralNotification : false
/// NewReleasesMovie : false
/// AppUpdate : false
/// Subscription : false

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));
String notificationToJson(Notification data) => json.encode(data.toJson());
class Notification {
  Notification({
      bool? generalNotification, 
      bool? newReleasesMovie, 
      bool? appUpdate, 
      bool? subscription,}){
    _generalNotification = generalNotification;
    _newReleasesMovie = newReleasesMovie;
    _appUpdate = appUpdate;
    _subscription = subscription;
}

  Notification.fromJson(dynamic json) {
    _generalNotification = json['GeneralNotification'];
    _newReleasesMovie = json['NewReleasesMovie'];
    _appUpdate = json['AppUpdate'];
    _subscription = json['Subscription'];
  }
  bool? _generalNotification;
  bool? _newReleasesMovie;
  bool? _appUpdate;
  bool? _subscription;
Notification copyWith({  bool? generalNotification,
  bool? newReleasesMovie,
  bool? appUpdate,
  bool? subscription,
}) => Notification(  generalNotification: generalNotification ?? _generalNotification,
  newReleasesMovie: newReleasesMovie ?? _newReleasesMovie,
  appUpdate: appUpdate ?? _appUpdate,
  subscription: subscription ?? _subscription,
);
  bool? get generalNotification => _generalNotification;
  bool? get newReleasesMovie => _newReleasesMovie;
  bool? get appUpdate => _appUpdate;
  bool? get subscription => _subscription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['GeneralNotification'] = _generalNotification;
    map['NewReleasesMovie'] = _newReleasesMovie;
    map['AppUpdate'] = _appUpdate;
    map['Subscription'] = _subscription;
    return map;
  }

}