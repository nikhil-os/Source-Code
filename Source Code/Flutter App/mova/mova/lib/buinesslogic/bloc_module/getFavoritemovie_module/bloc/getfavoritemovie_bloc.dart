

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/getFavoritemovie_module/getfavoritemovie_resources/getfavoritemovie_repository.dart';
import 'package:webtime_movie_ocean/customModal/getFavoriteListMovie_modal.dart';

part 'getfavoritemovie_event.dart';
part 'getfavoritemovie_state.dart';

class GetfavoritemovieBloc extends Bloc<GetfavoritemovieEvent, GetfavoritemovieState> {
  final GetFavoriteMovieRepositroy _getFavoriteMovieRepositroy;

  GetfavoritemovieBloc(this._getFavoriteMovieRepositroy) : super(GetfavoritemovieInitial()) {
    on<GetfavoritemovieEvent>((event, emit) async {
      emit(GetfavoritemovieLoading());
      final favoriteMovieList = await _getFavoriteMovieRepositroy.favoriremovie();
      emit(GetfavoritemovieLoaded(favoriteMovieList));


    });
  }
}
