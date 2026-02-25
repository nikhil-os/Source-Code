import 'package:webtime_movie_ocean/customModal/MovieModal.dart';
import 'Allmovies_provider.dart';

class AllMoviesRepository {
  final _provider = AllmoviesProvider();

  Future<MovieModal> top10movies() {
    return _provider.allmovies();
  }
}
