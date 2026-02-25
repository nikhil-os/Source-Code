import 'dart:convert';

/// status : true
/// message : "Success"
/// user : {"notification":{"GeneralNotification":true,"NewReleasesMovie":true,"AppUpdate":true,"Subscription":true},"plan":{"planStartDate":"8/27/2024, 4:10:36 PM","planEndDate":"9/27/2024, 4:10:36 PM","premiumPlanId":{"_id":"6374db8a4dfaba297326ce1e","name":"test","isAutoRenew":false,"validity":1,"validityType":"month","dollar":2,"tag":"25%","productKey":"test","createdAt":"2022-11-16T12:46:02.893Z","updatedAt":"2024-07-18T17:28:23.279Z","planBenefit":["Enjoy Watching Premium Movie!!","Watching Ad Free Movie!!","Allows streaming of 4K","24*7 Full Speed All Time-free service of help","Enjoy Watching Premium Movie!!"]}},"_id":"66cda7112ed7fe11b7a7bba4","image":"https://codderlab.blr1.digitaloceanspaces.com/mova/userImage/scaled_pexels-photo-6500175.webp","fullName":"A","nickName":"A","email":"MovaUser123@gmail.com","gender":"Male","country":"Antigua and Barbuda","password":"HY00QNTG","uniqueId":"430440207","interest":["",""],"fcmToken":"c1cxB_l5Tw2lRR4iBN2WvG:APA91bFHFjm3aEEAy55w9ThqMaJLlWVlsCoT4o2OpBD2sgBMVpDoDoOTROmcIVrhDBduYhj99p4ow2ugsSDrQN5MJ2JMs7lspij0nJUc355PwCcDy2lMMf_EFw_pEWFVXwKTlXgCJnFm","isBlock":false,"isPremiumPlan":true,"referralCode":"WG19UC4H","date":"8/27/2024, 3:44:41 PM","loginType":2,"identity":"89f7e86a4eee8eda","createdAt":"2024-08-27T10:14:41.298Z","updatedAt":"2024-08-27T10:40:36.383Z"}

FetchProfileModel fetchProfileModelFromJson(String str) => FetchProfileModel.fromJson(json.decode(str));
String fetchProfileModelToJson(FetchProfileModel data) => json.encode(data.toJson());

class FetchProfileModel {
  FetchProfileModel({
    bool? status,
    String? message,
    User? user,
  }) {
    _status = status;
    _message = message;
    _user = user;
  }

  FetchProfileModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  bool? _status;
  String? _message;
  User? _user;
  FetchProfileModel copyWith({
    bool? status,
    String? message,
    User? user,
  }) =>
      FetchProfileModel(
        status: status ?? _status,
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

/// notification : {"GeneralNotification":true,"NewReleasesMovie":true,"AppUpdate":true,"Subscription":true}
/// plan : {"planStartDate":"8/27/2024, 4:10:36 PM","planEndDate":"9/27/2024, 4:10:36 PM","premiumPlanId":{"_id":"6374db8a4dfaba297326ce1e","name":"test","isAutoRenew":false,"validity":1,"validityType":"month","dollar":2,"tag":"25%","productKey":"test","createdAt":"2022-11-16T12:46:02.893Z","updatedAt":"2024-07-18T17:28:23.279Z","planBenefit":["Enjoy Watching Premium Movie!!","Watching Ad Free Movie!!","Allows streaming of 4K","24*7 Full Speed All Time-free service of help","Enjoy Watching Premium Movie!!"]}}
/// _id : "66cda7112ed7fe11b7a7bba4"
/// image : "https://codderlab.blr1.digitaloceanspaces.com/mova/userImage/scaled_pexels-photo-6500175.webp"
/// fullName : "A"
/// nickName : "A"
/// email : "MovaUser123@gmail.com"
/// gender : "Male"
/// country : "Antigua and Barbuda"
/// password : "HY00QNTG"
/// uniqueId : "430440207"
/// interest : ["",""]
/// fcmToken : "c1cxB_l5Tw2lRR4iBN2WvG:APA91bFHFjm3aEEAy55w9ThqMaJLlWVlsCoT4o2OpBD2sgBMVpDoDoOTROmcIVrhDBduYhj99p4ow2ugsSDrQN5MJ2JMs7lspij0nJUc355PwCcDy2lMMf_EFw_pEWFVXwKTlXgCJnFm"
/// isBlock : false
/// isPremiumPlan : true
/// referralCode : "WG19UC4H"
/// date : "8/27/2024, 3:44:41 PM"
/// loginType : 2
/// identity : "89f7e86a4eee8eda"
/// createdAt : "2024-08-27T10:14:41.298Z"
/// updatedAt : "2024-08-27T10:40:36.383Z"

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
    String? fcmToken,
    bool? isBlock,
    bool? isPremiumPlan,
    String? referralCode,
    String? date,
    num? loginType,
    String? identity,
    String? createdAt,
    String? updatedAt,
  }) {
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
    _fcmToken = fcmToken;
    _isBlock = isBlock;
    _isPremiumPlan = isPremiumPlan;
    _referralCode = referralCode;
    _date = date;
    _loginType = loginType;
    _identity = identity;
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
    _fcmToken = json['fcmToken'];
    _isBlock = json['isBlock'];
    _isPremiumPlan = json['isPremiumPlan'];
    _referralCode = json['referralCode'];
    _date = json['date'];
    _loginType = json['loginType'];
    _identity = json['identity'];
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
  String? _fcmToken;
  bool? _isBlock;
  bool? _isPremiumPlan;
  String? _referralCode;
  String? _date;
  num? _loginType;
  String? _identity;
  String? _createdAt;
  String? _updatedAt;
  User copyWith({
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
    String? fcmToken,
    bool? isBlock,
    bool? isPremiumPlan,
    String? referralCode,
    String? date,
    num? loginType,
    String? identity,
    String? createdAt,
    String? updatedAt,
  }) =>
      User(
        notification: notification ?? _notification,
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
        fcmToken: fcmToken ?? _fcmToken,
        isBlock: isBlock ?? _isBlock,
        isPremiumPlan: isPremiumPlan ?? _isPremiumPlan,
        referralCode: referralCode ?? _referralCode,
        date: date ?? _date,
        loginType: loginType ?? _loginType,
        identity: identity ?? _identity,
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
  String? get fcmToken => _fcmToken;
  bool? get isBlock => _isBlock;
  bool? get isPremiumPlan => _isPremiumPlan;
  String? get referralCode => _referralCode;
  String? get date => _date;
  num? get loginType => _loginType;
  String? get identity => _identity;
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
    map['fcmToken'] = _fcmToken;
    map['isBlock'] = _isBlock;
    map['isPremiumPlan'] = _isPremiumPlan;
    map['referralCode'] = _referralCode;
    map['date'] = _date;
    map['loginType'] = _loginType;
    map['identity'] = _identity;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

/// planStartDate : "8/27/2024, 4:10:36 PM"
/// planEndDate : "9/27/2024, 4:10:36 PM"
/// premiumPlanId : {"_id":"6374db8a4dfaba297326ce1e","name":"test","isAutoRenew":false,"validity":1,"validityType":"month","dollar":2,"tag":"25%","productKey":"test","createdAt":"2022-11-16T12:46:02.893Z","updatedAt":"2024-07-18T17:28:23.279Z","planBenefit":["Enjoy Watching Premium Movie!!","Watching Ad Free Movie!!","Allows streaming of 4K","24*7 Full Speed All Time-free service of help","Enjoy Watching Premium Movie!!"]}

Plan planFromJson(String str) => Plan.fromJson(json.decode(str));
String planToJson(Plan data) => json.encode(data.toJson());

class Plan {
  Plan({
    String? planStartDate,
    String? planEndDate,
    PremiumPlanId? premiumPlanId,
  }) {
    _planStartDate = planStartDate;
    _planEndDate = planEndDate;
    _premiumPlanId = premiumPlanId;
  }

  Plan.fromJson(dynamic json) {
    _planStartDate = json['planStartDate'];
    _planEndDate = json['planEndDate'];
    _premiumPlanId = json['premiumPlanId'] != null ? PremiumPlanId.fromJson(json['premiumPlanId']) : null;
  }
  String? _planStartDate;
  String? _planEndDate;
  PremiumPlanId? _premiumPlanId;
  Plan copyWith({
    String? planStartDate,
    String? planEndDate,
    PremiumPlanId? premiumPlanId,
  }) =>
      Plan(
        planStartDate: planStartDate ?? _planStartDate,
        planEndDate: planEndDate ?? _planEndDate,
        premiumPlanId: premiumPlanId ?? _premiumPlanId,
      );
  String? get planStartDate => _planStartDate;
  String? get planEndDate => _planEndDate;
  PremiumPlanId? get premiumPlanId => _premiumPlanId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['planStartDate'] = _planStartDate;
    map['planEndDate'] = _planEndDate;
    if (_premiumPlanId != null) {
      map['premiumPlanId'] = _premiumPlanId?.toJson();
    }
    return map;
  }
}

/// _id : "6374db8a4dfaba297326ce1e"
/// name : "test"
/// isAutoRenew : false
/// validity : 1
/// validityType : "month"
/// dollar : 2
/// tag : "25%"
/// productKey : "test"
/// createdAt : "2022-11-16T12:46:02.893Z"
/// updatedAt : "2024-07-18T17:28:23.279Z"
/// planBenefit : ["Enjoy Watching Premium Movie!!","Watching Ad Free Movie!!","Allows streaming of 4K","24*7 Full Speed All Time-free service of help","Enjoy Watching Premium Movie!!"]

PremiumPlanId premiumPlanIdFromJson(String str) => PremiumPlanId.fromJson(json.decode(str));
String premiumPlanIdToJson(PremiumPlanId data) => json.encode(data.toJson());

class PremiumPlanId {
  PremiumPlanId({
    String? id,
    String? name,
    bool? isAutoRenew,
    num? validity,
    String? validityType,
    num? dollar,
    String? tag,
    String? productKey,
    String? createdAt,
    String? updatedAt,
    List<String>? planBenefit,
  }) {
    _id = id;
    _name = name;
    _isAutoRenew = isAutoRenew;
    _validity = validity;
    _validityType = validityType;
    _dollar = dollar;
    _tag = tag;
    _productKey = productKey;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _planBenefit = planBenefit;
  }

  PremiumPlanId.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _isAutoRenew = json['isAutoRenew'];
    _validity = json['validity'];
    _validityType = json['validityType'];
    _dollar = json['dollar'];
    _tag = json['tag'];
    _productKey = json['productKey'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _planBenefit = json['planBenefit'] != null ? json['planBenefit'].cast<String>() : [];
  }
  String? _id;
  String? _name;
  bool? _isAutoRenew;
  num? _validity;
  String? _validityType;
  num? _dollar;
  String? _tag;
  String? _productKey;
  String? _createdAt;
  String? _updatedAt;
  List<String>? _planBenefit;
  PremiumPlanId copyWith({
    String? id,
    String? name,
    bool? isAutoRenew,
    num? validity,
    String? validityType,
    num? dollar,
    String? tag,
    String? productKey,
    String? createdAt,
    String? updatedAt,
    List<String>? planBenefit,
  }) =>
      PremiumPlanId(
        id: id ?? _id,
        name: name ?? _name,
        isAutoRenew: isAutoRenew ?? _isAutoRenew,
        validity: validity ?? _validity,
        validityType: validityType ?? _validityType,
        dollar: dollar ?? _dollar,
        tag: tag ?? _tag,
        productKey: productKey ?? _productKey,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        planBenefit: planBenefit ?? _planBenefit,
      );
  String? get id => _id;
  String? get name => _name;
  bool? get isAutoRenew => _isAutoRenew;
  num? get validity => _validity;
  String? get validityType => _validityType;
  num? get dollar => _dollar;
  String? get tag => _tag;
  String? get productKey => _productKey;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<String>? get planBenefit => _planBenefit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['isAutoRenew'] = _isAutoRenew;
    map['validity'] = _validity;
    map['validityType'] = _validityType;
    map['dollar'] = _dollar;
    map['tag'] = _tag;
    map['productKey'] = _productKey;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['planBenefit'] = _planBenefit;
    return map;
  }
}

/// GeneralNotification : true
/// NewReleasesMovie : true
/// AppUpdate : true
/// Subscription : true

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));
String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    bool? generalNotification,
    bool? newReleasesMovie,
    bool? appUpdate,
    bool? subscription,
  }) {
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
  Notification copyWith({
    bool? generalNotification,
    bool? newReleasesMovie,
    bool? appUpdate,
    bool? subscription,
  }) =>
      Notification(
        generalNotification: generalNotification ?? _generalNotification,
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
