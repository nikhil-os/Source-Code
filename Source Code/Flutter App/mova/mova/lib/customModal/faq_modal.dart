import 'dart:convert';

/// status : true
/// message : "Successful!!"
/// FaQ : [{"isView":false,"_id":"637613c72e5b0408f92f83f5","question":"What is WebTime Movie Ocean???","answer":"Lorem ipsum may be used as a placeholder before fnal copy is available.","createdAt":"2022-11-17T10:58:15.811Z","updatedAt":"2022-12-20T03:47:18.597Z","__v":0},{"isView":false,"_id":"637de0457a4d62d4b4378a2b","question":"How do I can download movies?","answer":"In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document. ","createdAt":"2022-11-23T08:56:37.135Z","updatedAt":"2022-12-15T11:54:07.454Z","__v":0},{"isView":false,"_id":"637de3e17a4d62d4b4378b18","question":"How to remove Wishlist?","answer":"What do we mean by Free Text? Free Text is the string based data that comes from allowing people to type answers in to systems and forms. ","createdAt":"2022-11-23T09:12:01.015Z","updatedAt":"2022-12-12T11:12:31.208Z","__v":0}]

FaqModal faqModalFromJson(String str) => FaqModal.fromJson(json.decode(str));
String faqModalToJson(FaqModal data) => json.encode(data.toJson());

class FaqModal {
  FaqModal({
    bool? status,
    String? message,
    List<FaQ>? faQ,
  }) {
    _status = status;
    _message = message;
    _faQ = faQ;
  }

  FaqModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['FaQ'] != null) {
      _faQ = [];
      json['FaQ'].forEach((v) {
        _faQ?.add(FaQ.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<FaQ>? _faQ;
  FaqModal copyWith({
    bool? status,
    String? message,
    List<FaQ>? faQ,
  }) =>
      FaqModal(
        status: status ?? _status,
        message: message ?? _message,
        faQ: faQ ?? _faQ,
      );
  bool? get status => _status;
  String? get message => _message;
  List<FaQ>? get faQ => _faQ;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_faQ != null) {
      map['FaQ'] = _faQ?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// isView : false
/// _id : "637613c72e5b0408f92f83f5"
/// question : "What is WebTime Movie Ocean???"
/// answer : "Lorem ipsum may be used as a placeholder before fnal copy is available."
/// createdAt : "2022-11-17T10:58:15.811Z"
/// updatedAt : "2022-12-20T03:47:18.597Z"
/// __v : 0

FaQ faQFromJson(String str) => FaQ.fromJson(json.decode(str));
String faQToJson(FaQ data) => json.encode(data.toJson());

class FaQ {
  FaQ({
    bool? isView,
    String? id,
    String? question,
    String? answer,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _isView = isView;
    _id = id;
    _question = question;
    _answer = answer;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  FaQ.fromJson(dynamic json) {
    _isView = json['isView'];
    _id = json['_id'];
    _question = json['question'];
    _answer = json['answer'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  bool? _isView;
  String? _id;
  String? _question;
  String? _answer;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  FaQ copyWith({
    bool? isView,
    String? id,
    String? question,
    String? answer,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) =>
      FaQ(
        isView: isView ?? _isView,
        id: id ?? _id,
        question: question ?? _question,
        answer: answer ?? _answer,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
      );
  bool? get isView => _isView;
  String? get id => _id;
  String? get question => _question;
  String? get answer => _answer;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isView'] = _isView;
    map['_id'] = _id;
    map['question'] = _question;
    map['answer'] = _answer;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}
