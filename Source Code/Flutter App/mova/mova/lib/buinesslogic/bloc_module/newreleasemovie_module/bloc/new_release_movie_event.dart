part of 'new_release_movie_bloc.dart';

@immutable
abstract class NewReleaseMovieEvent extends Equatable{
  const NewReleaseMovieEvent();
}

class GetNewReleasemovie extends NewReleaseMovieEvent{
  @override
  List<Object> get props => [];
}