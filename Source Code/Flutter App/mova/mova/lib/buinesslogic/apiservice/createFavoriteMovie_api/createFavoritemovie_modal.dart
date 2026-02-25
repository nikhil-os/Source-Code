// ignore_for_file: file_names

class CreatefavoritemovieModal {
  CreatefavoritemovieModal({
      bool? status, 
      String? message, 
      bool? isFavorite,}){
    _status = status;
    _message = message;
    _isFavorite = isFavorite;
}

  CreatefavoritemovieModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _isFavorite = json['isFavorite'];
  }
  bool? _status;
  String? _message;
  bool? _isFavorite;
CreatefavoritemovieModal copyWith({  bool? status,
  String? message,
  bool? isFavorite,
}) => CreatefavoritemovieModal(  status: status ?? _status,
  message: message ?? _message,
  isFavorite: isFavorite ?? _isFavorite,
);
  bool? get status => _status;
  String? get message => _message;
  bool? get isFavorite => _isFavorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['isFavorite'] = _isFavorite;
    return map;
  }

}