class CategoriesModal {
  CategoriesModal({
    bool? status,
    String? message,
    List<Category>? category,
  }) {
    _status = status;
    _message = message;
    _category = category;
  }

  CategoriesModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['category'] != null) {
      _category = [];
      json['category'].forEach((v) {
        _category?.add(Category.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Category>? _category;
  CategoriesModal copyWith({
    bool? status,
    String? message,
    List<Category>? category,
  }) =>
      CategoriesModal(
        status: status ?? _status,
        message: message ?? _message,
        category: category ?? _category,
      );
  bool? get status => _status;
  String? get message => _message;
  List<Category>? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_category != null) {
      map['category'] = _category?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Category {
  Category({
    String? id,
    String? image,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _image = image;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Category.fromJson(dynamic json) {
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
  Category copyWith({
    String? id,
    String? image,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) =>
      Category(
        id: id ?? _id,
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
