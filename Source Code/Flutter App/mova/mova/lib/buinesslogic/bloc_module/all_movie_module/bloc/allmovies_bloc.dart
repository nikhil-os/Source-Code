import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/all_movie_module/Allmovi_resources/Allmovies_repository.dart';
import 'package:webtime_movie_ocean/customModal/MovieModal.dart';

part 'allmovies_event.dart';
part 'allmovies_state.dart';

class AllMoviesBloc extends Bloc<AllMoviesEvent, AllMoviesState> {
  final AllMoviesRepository _allMoviesRepository;
  bool _hasLoaded = false; // Track loading state

  AllMoviesBloc(this._allMoviesRepository) : super(AllMoviesInitial()) {
    on<GetAllMovie>((event, emit) async {
      if (!_hasLoaded) {
        // Only fetch if not already loaded
        emit(AllMoviesLoading());
        try {
          final allMovieList = await _allMoviesRepository.top10movies();
          _hasLoaded = true;
          emit(AllMoviesLoaded(allMovieList));
        } catch (e) {
          emit(AllMoviesError());
        }
      }
    });
  }

  // Optional: Method to force refresh
  void forceRefresh() {
    _hasLoaded = false;
    add(GetAllMovie());
  }
}
