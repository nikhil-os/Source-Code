part of 'new_release_movie_bloc.dart';

@immutable
abstract class NewReleaseMovieState extends Equatable {
  const NewReleaseMovieState();
  List<Object> get props => [];
}

class NewReleaseMovieInitial extends NewReleaseMovieState {}
class NewReleaseMovieLoading extends NewReleaseMovieState {

}
class NewReleaseMovieLoaded extends NewReleaseMovieState {
  final HomeMovieModal movieModal;
  const NewReleaseMovieLoaded(this.movieModal);
  @override
  List<Object> get props => [movieModal];
}
class NewReleaseMovieError extends NewReleaseMovieState {

}
