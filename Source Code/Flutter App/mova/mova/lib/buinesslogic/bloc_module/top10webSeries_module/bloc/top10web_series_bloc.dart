import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/top10webSeries_module/top10webSeries_resources/top10webSeries_repository.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';

part 'top10web_series_event.dart';
part 'top10web_series_state.dart';

class Top10webSeriesBloc extends Bloc<Top10webSeriesEvent, Top10webSeriesState> {
  final Top10WebSeriesRepository _top10webSeriesRepository;

  Top10webSeriesBloc(this._top10webSeriesRepository)
      : super(Top10webSeriesInitial()) {
    on<Top10webSeriesEvent>((event, emit) async {
      // TODO: implement event handler
      emit(Top10webSeriesLoading());
      final top10webSeriesList =
          await _top10webSeriesRepository.top10webSeries();
      emit(Top10webSeriesLoaded(top10webSeriesList));
    });
  }
}
