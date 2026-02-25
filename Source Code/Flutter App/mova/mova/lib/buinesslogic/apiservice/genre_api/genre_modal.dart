

class GenreModal {
  GenreModal({
      bool? status, 
      String? message, 
      List<Genre>? genre,}){
    _status = status;
    _message = message;
    _genre = genre;
}

  GenreModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['genre'] != null) {
      _genre = [];
      json['genre'].forEach((v) {
        _genre?.add(Genre.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Genre>? _genre;
GenreModal copyWith({  bool? status,
  String? message,
  List<Genre>? genre,
}) => GenreModal(  status: status ?? _status,
  message: message ?? _message,
  genre: genre ?? _genre,
);
  bool? get status => _status;
  String? get message => _message;
  List<Genre>? get genre => _genre;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_genre != null) {
      map['genre'] = _genre?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class Genre {
  Genre({
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

  Genre.fromJson(dynamic json) {
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
Genre copyWith({  String? id,
  String? image,
  String? name,
  String? createdAt,
  String? updatedAt,
}) => Genre(  id: id ?? _id,
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