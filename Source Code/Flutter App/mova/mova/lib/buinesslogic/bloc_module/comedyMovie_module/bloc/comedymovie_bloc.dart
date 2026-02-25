import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/comedyMovie_module/comedymovie_resources/comedymovie_repository.dart';
import 'package:webtime_movie_ocean/customModal/HomeMovieModal.dart';

part 'comedymovie_event.dart';
part 'comedymovie_state.dart';

class ComedyMovieBloc extends Bloc<ComedyMovieEvent, ComedymovieState> {
  final ComedyMovieRepository _comedyMovieRepository;
  ComedyMovieBloc(this._comedyMovieRepository) : super(ComedymovieInitial()) {
    on<ComedyMovieEvent>((event, emit) async {
      emit(ComedymovieLoading());
      final comedyMovieList = await _comedyMovieRepository.comedymovies();
      emit(ComedymovieLoaded(comedyMovieList));
    });
  }
}
