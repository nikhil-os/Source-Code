import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/top10movie_module/top10movies_resources/top10movies_repository.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';

part 'top10movies_event.dart';
part 'top10movies_state.dart';

class Top10moviesBloc extends Bloc<Top10moviesEvent, Top10moviesState> {
  final Top10MoviesRepository _top10moviesRepository;

  Top10moviesBloc(this._top10moviesRepository) : super(Top10moviesInitial()) {
    on<Top10moviesEvent>((event, emit) async {
      // TODO: implement event handler
      emit(Top10moviesLoading());
      final top10moviesList = await _top10moviesRepository.top10movies();
      emit(Top10moviesLoaded(top10moviesList));
    });
  }
}
