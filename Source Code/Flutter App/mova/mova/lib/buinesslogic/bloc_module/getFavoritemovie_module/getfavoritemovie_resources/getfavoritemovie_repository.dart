import 'package:webtime_movie_ocean/customModal/getFavoriteListMovie_modal.dart';
import 'getfavoritemovie_provider.dart';

class GetFavoriteMovieRepositroy {
  final _provider = GetFavoritemovie();

  Future<GetFavoriteListMovieModal> favoriremovie(){
    return _provider.getfavoritemovie();
  }
}