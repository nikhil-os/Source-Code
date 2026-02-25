import 'dart:convert';

CompleteMovieDataModal completeMovieDataModalFromJson(String str) =>
    CompleteMovieDataModal.fromJson(json.decode(str));

String completeMovieDataModalToJson(CompleteMovieDataModal data) =>
    json.encode(data.toJson());

class CompleteMovieDataModal {
  CompleteMovieDataModal({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) {
    _status = status;
    _message = message;
    _movie = movie;
  }

  CompleteMovieDataModal.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['movie'] != null) {
      _movie = [];
      json['movie'].forEach((v) {
        _movie?.add(Movie.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Movie>? _movie;

  CompleteMovieDataModal copyWith({
    bool? status,
    String? message,
    List<Movie>? movie,
  }) =>
      CompleteMovieDataModal(
        status: status ?? _status,
        message: message ?? _message,
        movie: movie ?? _movie,
      );

  bool? get status => _status;

  String? get message => _message;

  List<Movie>? get movie => _movie;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_movie != null) {
      map['movie'] = _movie?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Movie movieFromJson(String str) => Movie.fromJson(json.decode(str));

String movieToJson(Movie data) => json.encode(data.toJson());

class Movie {
  Movie({
    String? id,
    String? type,
    String? link,
    bool? isNewRelease,
    List<Genre>? genre,
    num? view,
    num? videoType,
    num? comment,
    Region? region,
    String? title,
    String? year,
    String? description,
    String? image,
    String? tmdbMovieId,
    String? iMDBid,
    String? mediaType,
    String? runtime,
    bool? isDownload,
    bool? isFavorite,
    bool? isPlan,
    bool? isRating,
    List<Episode>? episode,
    List<Trailer>? trailer,
    List<Role>? role,
    List<Season>? season,
    num? rating,
    bool? isRentable,
    String? rentalCurrency,
    List<RentalOption>? rentalOptions,
  }) {
    _id = id;
    _type = type;
    _link = link;
    _isNewRelease = isNewRelease;
    _genre = genre;
    _view = view;
    _videoType = videoType;
    _comment = comment;
    _region = region;
    _title = title;
    _year = year;
    _description = description;
    _image = image;
    _tmdbMovieId = tmdbMovieId;
    _iMDBid = iMDBid;
    _mediaType = mediaType;
    _runtime = runtime;
    _isDownload = isDownload;
    _isFavorite = isFavorite;
    _isPlan = isPlan;
    _isRating = isRating;
    _episode = episode;
    _trailer = trailer;
    _role = role;
    _season = season;
    _rating = rating;
    _isRentable = isRentable;
    _rentalCurrency = rentalCurrency;
    _rentalOptions = rentalOptions;
  }

  Movie.fromJson(dynamic json) {
    _id = json['_id'];
    _type = json['type'];
    _link = json['link'];
    _isNewRelease = json['isNewRelease'];
    if (json['genre'] != null) {
      _genre = [];
      json['genre'].forEach((v) {
        _genre?.add(Genre.fromJson(v));
      });
    }
    _view = json['view'];
    _videoType = json['videoType'];
    _comment = json['comment'];
    _region = json['region'] != null ? Region.fromJson(json['region']) : null;
    _title = json['title'];
    _year = json['year'];
    _description = json['description'];
    _image = json['image'];
    _tmdbMovieId = json['TmdbMovieId'];
    _iMDBid = json['IMDBid'];
    _mediaType = json['media_type'];
    _runtime = json['runtime'];
    _isDownload = json['isDownload'];
    _isFavorite = json['isFavorite'];
    _isPlan = json['isPlan'];
    _isRating = json['isRating'];
    if (json['episode'] != null) {
      _episode = [];
      json['episode'].forEach((v) {
        _episode?.add(Episode.fromJson(v));
      });
    }
    if (json['trailer'] != null) {
      _trailer = [];
      json['trailer'].forEach((v) {
        _trailer?.add(Trailer.fromJson(v));
      });
    }
    if (json['role'] != null) {
      _role = [];
      json['role'].forEach((v) {
        _role?.add(Role.fromJson(v));
      });
    }
    if (json['season'] != null) {
      _season = [];
      json['season'].forEach((v) {
        _season?.add(Season.fromJson(v));
      });
    }
    _rating = json['rating'];
    _isRentable = json['isRentable'] ?? false;
    _rentalCurrency = json['rentalCurrency'];
    if (json['rentalOptions'] != null) {
      _rentalOptions = [];
      json['rentalOptions'].forEach((v) {
        _rentalOptions?.add(RentalOption.fromJson(v));
      });
    }
  }

  String? _id;
  String? _type;
  String? _link;
  bool? _isNewRelease;
  List<Genre>? _genre;
  num? _view;
  num? _videoType;
  num? _comment;
  Region? _region;
  String? _title;
  String? _year;
  String? _description;
  String? _image;
  String? _tmdbMovieId;
  String? _iMDBid;
  String? _mediaType;
  String? _runtime;
  bool? _isDownload;
  bool? _isFavorite;
  bool? _isPlan;
  bool? _isRating;
  List<Episode>? _episode;
  List<Trailer>? _trailer;
  List<Role>? _role;
  List<Season>? _season;
  num? _rating;
  bool? _isRentable;
  String? _rentalCurrency;
  List<RentalOption>? _rentalOptions;

  Movie copyWith({
    String? id,
    String? type,
    String? link,
    bool? isNewRelease,
    List<Genre>? genre,
    num? view,
    num? videoType,
    num? comment,
    Region? region,
    String? title,
    String? year,
    String? description,
    String? image,
    String? tmdbMovieId,
    String? iMDBid,
    String? mediaType,
    String? runtime,
    bool? isDownload,
    bool? isFavorite,
    bool? isPlan,
    bool? isRating,
    List<Episode>? episode,
    List<Trailer>? trailer,
    List<Role>? role,
    List<Season>? season,
    num? rating,
    bool? isRentable,
    String? rentalCurrency,
    List<RentalOption>? rentalOptions,
  }) =>
      Movie(
        id: id ?? _id,
        type: type ?? _type,
        link: link ?? _link,
        isNewRelease: isNewRelease ?? _isNewRelease,
        genre: genre ?? _genre,
        view: view ?? _view,
        videoType: videoType ?? _videoType,
        comment: comment ?? _comment,
        region: region ?? _region,
        title: title ?? _title,
        year: year ?? _year,
        description: description ?? _description,
        image: image ?? _image,
        tmdbMovieId: tmdbMovieId ?? _tmdbMovieId,
        iMDBid: iMDBid ?? _iMDBid,
        mediaType: mediaType ?? _mediaType,
        runtime: runtime ?? _runtime,
        isDownload: isDownload ?? _isDownload,
        isFavorite: isFavorite ?? _isFavorite,
        isPlan: isPlan ?? _isPlan,
        isRating: isRating ?? _isRating,
        episode: episode ?? _episode,
        trailer: trailer ?? _trailer,
        role: role ?? _role,
        season: season ?? _season,
        rating: rating ?? _rating,
        isRentable: isRentable ?? _isRentable,
        rentalCurrency: rentalCurrency ?? _rentalCurrency,
        rentalOptions: rentalOptions ?? _rentalOptions,
      );

  String? get id => _id;

  String? get type => _type;

  String? get link => _link;

  bool? get isNewRelease => _isNewRelease;

  List<Genre>? get genre => _genre;

  num? get view => _view;
  num? get videoType => _videoType;

  num? get comment => _comment;

  Region? get region => _region;

  String? get title => _title;

  String? get year => _year;

  String? get description => _description;

  String? get image => _image;

  String? get tmdbMovieId => _tmdbMovieId;
  String? get iMDBid => _iMDBid;

  String? get mediaType => _mediaType;

  String? get runtime => _runtime;

  bool? get isDownload => _isDownload;

  bool? get isFavorite => _isFavorite;

  bool? get isPlan => _isPlan;

  bool? get isRating => _isRating;

  List<Episode>? get episode => _episode;

  List<Trailer>? get trailer => _trailer;

  List<Role>? get role => _role;

  List<Season>? get season => _season;

  num? get rating => _rating;

  bool? get isRentable => _isRentable;
  String? get rentalCurrency => _rentalCurrency;
  List<RentalOption>? get rentalOptions => _rentalOptions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['link'] = _link;
    map['type'] = _type;
    map['isNewRelease'] = _isNewRelease;
    if (_genre != null) {
      map['genre'] = _genre?.map((v) => v.toJson()).toList();
    }
    map['view'] = _view;
    map['videoType'] = _videoType;
    map['comment'] = _comment;
    if (_region != null) {
      map['region'] = _region?.toJson();
    }
    map['title'] = _title;
    map['year'] = _year;
    map['description'] = _description;
    map['image'] = _image;
    map['TmdbMovieId'] = _tmdbMovieId;
    map['IMDBid'] = _iMDBid;
    map['media_type'] = _mediaType;
    map['runtime'] = _runtime;
    map['isDownload'] = _isDownload;
    map['isFavorite'] = _isFavorite;
    map['isPlan'] = _isPlan;
    map['isRating'] = _isRating;
    if (_episode != null) {
      map['episode'] = _episode?.map((v) => v.toJson()).toList();
    }
    if (_trailer != null) {
      map['trailer'] = _trailer?.map((v) => v.toJson()).toList();
    }
    if (_role != null) {
      map['role'] = _role?.map((v) => v.toJson()).toList();
    }
    if (_season != null) {
      map['season'] = _season?.map((v) => v.toJson()).toList();
    }
    map['rating'] = _rating;
    map['isRentable'] = _isRentable;
    map['rentalCurrency'] = _rentalCurrency;
    if (_rentalOptions != null) {
      map['rentalOptions'] = _rentalOptions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RentalOption {
  RentalOption({
    num? duration,
    String? durationLabel,
    num? price,
  }) {
    _duration = duration;
    _durationLabel = durationLabel;
    _price = price;
  }

  RentalOption.fromJson(dynamic json) {
    _duration = json['duration'];
    _durationLabel = json['durationLabel'];
    _price = json['price'];
  }

  num? _duration;
  String? _durationLabel;
  num? _price;

  num? get duration => _duration;
  String? get durationLabel => _durationLabel;
  num? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['duration'] = _duration;
    map['durationLabel'] = _durationLabel;
    map['price'] = _price;
    return map;
  }
}

Season seasonFromJson(String str) => Season.fromJson(json.decode(str));

String seasonToJson(Season data) => json.encode(data.toJson());

class Season {
  Season({
    String? id,
    String? name,
    num? seasonNumber,
    num? episodeCount,
    String? image,
    String? releaseDate,
    String? tmdbSeasonId,
    String? movie,
  }) {
    _id = id;
    _name = name;
    _seasonNumber = seasonNumber;
    _episodeCount = episodeCount;
    _image = image;
    _releaseDate = releaseDate;
    _tmdbSeasonId = tmdbSeasonId;
    _movie = movie;
  }

  Season.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _seasonNumber = json['seasonNumber'];
    _episodeCount = json['episodeCount'];
    _image = json['image'];
    _releaseDate = json['releaseDate'];
    _tmdbSeasonId = json['TmdbSeasonId'];
    _movie = json['movie'];
  }

  String? _id;
  String? _name;
  num? _seasonNumber;
  num? _episodeCount;
  String? _image;
  String? _releaseDate;
  String? _tmdbSeasonId;
  String? _movie;

  Season copyWith({
    String? id,
    String? name,
    num? seasonNumber,
    num? episodeCount,
    String? image,
    String? releaseDate,
    String? tmdbSeasonId,
    String? movie,
  }) =>
      Season(
        id: id ?? _id,
        name: name ?? _name,
        seasonNumber: seasonNumber ?? _seasonNumber,
        episodeCount: episodeCount ?? _episodeCount,
        image: image ?? _image,
        releaseDate: releaseDate ?? _releaseDate,
        tmdbSeasonId: tmdbSeasonId ?? _tmdbSeasonId,
        movie: movie ?? _movie,
      );

  String? get id => _id;

  String? get name => _name;

  num? get seasonNumber => _seasonNumber;

  num? get episodeCount => _episodeCount;

  String? get image => _image;

  String? get releaseDate => _releaseDate;

  String? get tmdbSeasonId => _tmdbSeasonId;

  String? get movie => _movie;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['seasonNumber'] = _seasonNumber;
    map['episodeCount'] = _episodeCount;
    map['image'] = _image;
    map['releaseDate'] = _releaseDate;
    map['TmdbSeasonId'] = _tmdbSeasonId;
    map['movie'] = _movie;
    return map;
  }
}

Role roleFromJson(String str) => Role.fromJson(json.decode(str));

String roleToJson(Role data) => json.encode(data.toJson());

class Role {
  Role({
    String? id,
    String? name,
    String? image,
    String? position,
    String? movie,
  }) {
    _id = id;
    _name = name;
    _image = image;
    _position = position;
    _movie = movie;
  }

  Role.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _image = json['image'];
    _position = json['position'];
    _movie = json['movie'];
  }

  String? _id;
  String? _name;
  String? _image;
  String? _position;
  String? _movie;

  Role copyWith({
    String? id,
    String? name,
    String? image,
    String? position,
    String? movie,
  }) =>
      Role(
        id: id ?? _id,
        name: name ?? _name,
        image: image ?? _image,
        position: position ?? _position,
        movie: movie ?? _movie,
      );

  String? get id => _id;

  String? get name => _name;

  String? get image => _image;

  String? get position => _position;

  String? get movie => _movie;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['image'] = _image;
    map['position'] = _position;
    map['movie'] = _movie;
    return map;
  }
}

Trailer trailerFromJson(String str) => Trailer.fromJson(json.decode(str));

String trailerToJson(Trailer data) => json.encode(data.toJson());

class Trailer {
  Trailer({
    String? id,
    String? name,
    String? size,
    String? type,
    String? videoUrl,
    String? key,
    String? trailerImage,
    String? movie,
  }) {
    _id = id;
    _name = name;
    _size = size;
    _type = type;
    _videoUrl = videoUrl;
    _key = key;
    _trailerImage = trailerImage;
    _movie = movie;
  }

  Trailer.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _size = json['size'];
    _type = json['type'];
    _videoUrl = json['videoUrl'];
    _key = json['key'];
    _trailerImage = json['trailerImage'];
    _movie = json['movie'];
  }

  String? _id;
  String? _name;
  String? _size;
  String? _type;
  String? _videoUrl;
  String? _key;
  String? _trailerImage;
  String? _movie;

  Trailer copyWith({
    String? id,
    String? name,
    String? size,
    String? type,
    String? videoUrl,
    String? key,
    String? trailerImage,
    String? movie,
  }) =>
      Trailer(
        id: id ?? _id,
        name: name ?? _name,
        size: size ?? _size,
        type: type ?? _type,
        videoUrl: videoUrl ?? _videoUrl,
        key: key ?? _key,
        trailerImage: trailerImage ?? _trailerImage,
        movie: movie ?? _movie,
      );

  String? get id => _id;

  String? get name => _name;

  String? get size => _size;

  String? get type => _type;

  String? get videoUrl => _videoUrl;

  String? get key => _key;

  String? get trailerImage => _trailerImage;

  String? get movie => _movie;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['size'] = _size;
    map['type'] = _type;
    map['videoUrl'] = _videoUrl;
    map['key'] = _key;
    map['trailerImage'] = _trailerImage;
    map['movie'] = _movie;
    return map;
  }
}

Episode episodeFromJson(String str) => Episode.fromJson(json.decode(str));

String episodeToJson(Episode data) => json.encode(data.toJson());

class Episode {
  Episode({
    String? id,
    num? videoType,
    String? videoUrl,
    String? name,
    num? episodeNumber,
    String? image,
    num? seasonNumber,
    String? tmdbMovieId,
    String? movie,
  }) {
    _id = id;
    _videoType = videoType;
    _videoUrl = videoUrl;
    _name = name;
    _episodeNumber = episodeNumber;
    _image = image;
    _seasonNumber = seasonNumber;
    _tmdbMovieId = tmdbMovieId;
    _movie = movie;
  }

  Episode.fromJson(dynamic json) {
    _id = json['_id'];
    _videoType = json['videoType'];
    _videoUrl = json['videoUrl'];
    _name = json['name'];
    _episodeNumber = json['episodeNumber'];
    _image = json['image'];
    _seasonNumber = json['seasonNumber'];
    _tmdbMovieId = json['TmdbMovieId'];
    _movie = json['movie'];
  }

  String? _id;
  num? _videoType;
  String? _videoUrl;
  String? _name;
  num? _episodeNumber;
  String? _image;
  num? _seasonNumber;
  String? _tmdbMovieId;
  String? _movie;

  Episode copyWith({
    String? id,
    num? videoType,
    String? videoUrl,
    String? name,
    num? episodeNumber,
    String? image,
    num? seasonNumber,
    String? tmdbMovieId,
    String? movie,
  }) =>
      Episode(
        id: id ?? _id,
        videoType: videoType ?? _videoType,
        videoUrl: videoUrl ?? _videoUrl,
        name: name ?? _name,
        episodeNumber: episodeNumber ?? _episodeNumber,
        image: image ?? _image,
        seasonNumber: seasonNumber ?? _seasonNumber,
        tmdbMovieId: tmdbMovieId ?? _tmdbMovieId,
        movie: movie ?? _movie,
      );

  String? get id => _id;

  num? get videoType => _videoType;

  String? get videoUrl => _videoUrl;

  String? get name => _name;

  num? get episodeNumber => _episodeNumber;

  String? get image => _image;

  num? get seasonNumber => _seasonNumber;

  String? get tmdbMovieId => _tmdbMovieId;

  String? get movie => _movie;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['videoType'] = _videoType;
    map['videoUrl'] = _videoUrl;
    map['name'] = _name;
    map['episodeNumber'] = _episodeNumber;
    map['image'] = _image;
    map['seasonNumber'] = _seasonNumber;
    map['TmdbMovieId'] = _tmdbMovieId;
    map['movie'] = _movie;
    return map;
  }
}

Region regionFromJson(String str) => Region.fromJson(json.decode(str));

String regionToJson(Region data) => json.encode(data.toJson());

class Region {
  Region({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Region.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
  }

  String? _id;
  String? _name;

  Region copyWith({
    String? id,
    String? name,
  }) =>
      Region(
        id: id ?? _id,
        name: name ?? _name,
      );

  String? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    return map;
  }
}

Genre genreFromJson(String str) => Genre.fromJson(json.decode(str));

String genreToJson(Genre data) => json.encode(data.toJson());

class Genre {
  Genre({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Genre.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
  }

  String? _id;
  String? _name;

  Genre copyWith({
    String? id,
    String? name,
  }) =>
      Genre(
        id: id ?? _id,
        name: name ?? _name,
      );

  String? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    return map;
  }
}
