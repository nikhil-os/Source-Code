import 'package:webtime_movie_ocean/buinesslogic/bloc_module/top10movie_module/top10movies_resources/top10movies_provider.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';



class Top10MoviesRepository{
  final _provider = Top10MoviesProvider();


  Future<HomeMovieModal> top10movies(){
     return _provider.top10movies();
  }
}