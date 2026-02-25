

class RegionModal {
  RegionModal({
      bool? status, 
      String? message, 
      List<Region>? region,}){
    _status = status;
    _message = message;
    _region = region;
}

  RegionModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['region'] != null) {
      _region = [];
      json['region'].forEach((v) {
        _region?.add(Region.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Region>? _region;
RegionModal copyWith({  bool? status,
  String? message,
  List<Region>? region,
}) => RegionModal(  status: status ?? _status,
  message: message ?? _message,
  region: region ?? _region,
);
  bool? get status => _status;
  String? get message => _message;
  List<Region>? get region => _region;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_region != null) {
      map['region'] = _region?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class Region {
  Region({
      String? id, 
      String? image, 
      String? name, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _image = image;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Region.fromJson(dynamic json) {
    _id = json['_id'];
    _image = json['image'];
    _name = json['name'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _image;
  String? _name;
  String? _createdAt;
  String? _updatedAt;
Region copyWith({  String? id,
  String? image,
  String? name,
  String? createdAt,
  String? updatedAt,
}) => Region(  id: id ?? _id,
  image: image ?? _image,
  name: name ?? _name,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get image => _image;
  String? get name => _name;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['image'] = _image;
    map['name'] = _name;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}