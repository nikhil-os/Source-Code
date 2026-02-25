

class AdvertisementModal {
  AdvertisementModal({
      bool? status, 
      String? message, 
      Advertisement? advertisement,}){
    _status = status;
    _message = message;
    _advertisement = advertisement;
}

  AdvertisementModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _advertisement = json['advertisement'] != null ? Advertisement.fromJson(json['advertisement']) : null;
  }
  bool? _status;
  String? _message;
  Advertisement? _advertisement;
AdvertisementModal copyWith({  bool? status,
  String? message,
  Advertisement? advertisement,
}) => AdvertisementModal(  status: status ?? _status,
  message: message ?? _message,
  advertisement: advertisement ?? _advertisement,
);
  bool? get status => _status;
  String? get message => _message;
  Advertisement? get advertisement => _advertisement;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_advertisement != null) {
      map['advertisement'] = _advertisement?.toJson();
    }
    return map;
  }

}



class Advertisement {
  Advertisement({
      String? id, 
      String? native, 
      String? interstitial, 
      dynamic reward, 
      dynamic banner, 
      String? nativeIos, 
      dynamic rewardIos, 
      dynamic bannerIos, 
      String? interstitialIos, 
      bool? isGoogleAdd, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _native = native;
    _interstitial = interstitial;
    _reward = reward;
    _banner = banner;
    _nativeIos = nativeIos;
    _rewardIos = rewardIos;
    _bannerIos = bannerIos;
    _interstitialIos = interstitialIos;
    _isGoogleAdd = isGoogleAdd;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Advertisement.fromJson(dynamic json) {
    _id = json['_id'];
    _native = json['native'];
    _interstitial = json['interstitial'];
    _reward = json['reward'];
    _banner = json['banner'];
    _nativeIos = json['nativeIos'];
    _rewardIos = json['rewardIos'];
    _bannerIos = json['bannerIos'];
    _interstitialIos = json['interstitialIos'];
    _isGoogleAdd = json['isGoogleAdd'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _native;
  String? _interstitial;
  dynamic _reward;
  dynamic _banner;
  String? _nativeIos;
  dynamic _rewardIos;
  dynamic _bannerIos;
  String? _interstitialIos;
  bool? _isGoogleAdd;
  String? _createdAt;
  String? _updatedAt;
Advertisement copyWith({  String? id,
  String? native,
  String? interstitial,
  dynamic reward,
  dynamic banner,
  String? nativeIos,
  dynamic rewardIos,
  dynamic bannerIos,
  String? interstitialIos,
  bool? isGoogleAdd,
  String? createdAt,
  String? updatedAt,
}) => Advertisement(  id: id ?? _id,
  native: native ?? _native,
  interstitial: interstitial ?? _interstitial,
  reward: reward ?? _reward,
  banner: banner ?? _banner,
  nativeIos: nativeIos ?? _nativeIos,
  rewardIos: rewardIos ?? _rewardIos,
  bannerIos: bannerIos ?? _bannerIos,
  interstitialIos: interstitialIos ?? _interstitialIos,
  isGoogleAdd: isGoogleAdd ?? _isGoogleAdd,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get native => _native;
  String? get interstitial => _interstitial;
  dynamic get reward => _reward;
  dynamic get banner => _banner;
  String? get nativeIos => _nativeIos;
  dynamic get rewardIos => _rewardIos;
  dynamic get bannerIos => _bannerIos;
  String? get interstitialIos => _interstitialIos;
  bool? get isGoogleAdd => _isGoogleAdd;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['native'] = _native;
    map['interstitial'] = _interstitial;
    map['reward'] = _reward;
    map['banner'] = _banner;
    map['nativeIos'] = _nativeIos;
    map['rewardIos'] = _rewardIos;
    map['bannerIos'] = _bannerIos;
    map['interstitialIos'] = _interstitialIos;
    map['isGoogleAdd'] = _isGoogleAdd;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}