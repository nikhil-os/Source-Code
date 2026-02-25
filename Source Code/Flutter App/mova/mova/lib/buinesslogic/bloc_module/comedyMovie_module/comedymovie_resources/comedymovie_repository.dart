import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';
import 'comedymovie_provider.dart';


class ComedyMovieRepository{
  final _provider = ComedyMovieProvider();


  Future<HomeMovieModal> comedymovies(){
    return _provider.comedymovies();
  }
}