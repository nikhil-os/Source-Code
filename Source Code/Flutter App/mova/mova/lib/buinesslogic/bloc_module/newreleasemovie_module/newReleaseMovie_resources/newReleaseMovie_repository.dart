
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';
import 'newReleaseMovie_provider.dart';

class NewReleasemovieRepository {
  final _provider = NewReleaseMovieProvider();

  Future<HomeMovieModal> newReleaseMovie(){

    return _provider.newReleaseMovie();
}
}