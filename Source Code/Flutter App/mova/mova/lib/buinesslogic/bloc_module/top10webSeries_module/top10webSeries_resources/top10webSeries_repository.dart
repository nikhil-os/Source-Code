
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/top10webSeries_module/top10webSeries_resources/top10webSeries_provider.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';



class Top10WebSeriesRepository{
  final _provider = Top10WebSeriesProvider();


  Future<HomeMovieModal> top10webSeries(){
    return _provider.top10webSeries();
  }
}