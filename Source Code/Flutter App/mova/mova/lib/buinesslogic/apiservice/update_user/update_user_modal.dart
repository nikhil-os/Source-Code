/// status : true
/// message : "Success!!"
/// user : {"_id":"634108c4ea2785b41a81883c","image":"https://work8.digicean.com/storage/male.png","fullName":"ABCD","nickName":null,"email":"299460828","gender":"male","country":"USA","password":"RDHYVP7N","uniqueId":"299460828","interest":[],"referralCode":"XCHBDIU5","loginType":3,"identity":"4567547","createdAt":"2022-10-08T05:21:08.415Z","updatedAt":"2022-10-11T04:39:55.733Z"}
library;

class UpdateUserModal {
  UpdateUserModal({
    bool? status,
    String? message,
    User? user,
  }) {
    _status = status;
    _message = message;
    _user = user;
  }

  UpdateUserModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  bool? _status;
  String? _message;
  User? _user;
  UpdateUserModal copyWith({
    bool? status,
    String? message,
    User? user,
  }) =>
      UpdateUserModal(
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

/// _id : "634108c4ea2785b41a81883c"
/// image : "https://work8.digicean.com/storage/male.png"
/// fullName : "ABCD"
/// nickName : null
/// email : "299460828"
/// gender : "male"
/// country : "USA"
/// password : "RDHYVP7N"
/// uniqueId : "299460828"
/// interest : []
/// referralCode : "XCHBDIU5"
/// loginType : 3
/// identity : "4567547"
/// createdAt : "2022-10-08T05:21:08.415Z"
/// updatedAt : "2022-10-11T04:39:55.733Z"

class User {
  User({
    String? id,
    String? image,
    String? fullName,
    dynamic nickName,
    String? email,
    String? gender,
    String? country,
    String? password,
    String? uniqueId,
    List<dynamic>? interest,
    String? referralCode,
    num? loginType,
    String? identity,
    String? createdAt,
    String? updatedAt,
  }) {
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
    _referralCode = referralCode;
    _loginType = loginType;
    _identity = identity;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  User.fromJson(dynamic json) {
    _id = json['_id'];
    _image = json['image'];
    _fullName = json['fullName'];
    _nickName = json['nickName'];
    _email = json['email'];
    _gender = json['gender'];
    _country = json['country'];
    _password = json['password'];
    _uniqueId = json['uniqueId'];
    // if (json['interest'] != null) {
    //   _interest = [];
    //   json['interest'].forEach((v) {
    //     _interest?.add(Dynamic.fromJson(v));
    //   });
    // }
    _referralCode = json['referralCode'];
    _loginType = json['loginType'];
    _identity = json['identity'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _image;
  String? _fullName;
  dynamic _nickName;
  String? _email;
  String? _gender;
  String? _country;
  String? _password;
  String? _uniqueId;
  List<dynamic>? _interest;
  String? _referralCode;
  num? _loginType;
  String? _identity;
  String? _createdAt;
  String? _updatedAt;
  User copyWith({
    String? id,
    String? image,
    String? fullName,
    dynamic nickName,
    String? email,
    String? gender,
    String? country,
    String? password,
    String? uniqueId,
    List<dynamic>? interest,
    String? referralCode,
    num? loginType,
    String? identity,
    String? createdAt,
    String? updatedAt,
  }) =>
      User(
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
        referralCode: referralCode ?? _referralCode,
        loginType: loginType ?? _loginType,
        identity: identity ?? _identity,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  String? get id => _id;
  String? get image => _image;
  String? get fullName => _fullName;
  dynamic get nickName => _nickName;
  String? get email => _email;
  String? get gender => _gender;
  String? get country => _country;
  String? get password => _password;
  String? get uniqueId => _uniqueId;
  List<dynamic>? get interest => _interest;
  String? get referralCode => _referralCode;
  num? get loginType => _loginType;
  String? get identity => _identity;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['image'] = _image;
    map['fullName'] = _fullName;
    map['nickName'] = _nickName;
    map['email'] = _email;
    map['gender'] = _gender;
    map['country'] = _country;
    map['password'] = _password;
    map['uniqueId'] = _uniqueId;
    if (_interest != null) {
      map['interest'] = _interest?.map((v) => v.toJson()).toList();
    }
    map['referralCode'] = _referralCode;
    map['loginType'] = _loginType;
    map['identity'] = _identity;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
