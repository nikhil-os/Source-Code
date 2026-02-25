// ignore_for_file: non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/newreleasemovie_module/newReleaseMovie_resources/newReleaseMovie_repository.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';
part 'new_release_movie_event.dart';
part 'new_release_movie_state.dart';

class NewReleaseMovieBloc extends Bloc<NewReleaseMovieEvent, NewReleaseMovieState> {
final NewReleasemovieRepository _newReleasemovieRepository;

  NewReleaseMovieBloc(this._newReleasemovieRepository) : super(NewReleaseMovieInitial()) {

    on<NewReleaseMovieEvent>((event, emit) async{
      // TODO: implement event handler
      emit(NewReleaseMovieLoading());
      final NewReleaseMovieList = await _newReleasemovieRepository.newReleaseMovie();
      emit(NewReleaseMovieLoaded(NewReleaseMovieList));
    });
  }
}
