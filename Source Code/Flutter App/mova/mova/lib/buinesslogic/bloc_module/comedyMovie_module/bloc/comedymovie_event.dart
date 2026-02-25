part of 'comedymovie_bloc.dart';

@immutable
abstract class ComedyMovieEvent extends Equatable {
  const ComedyMovieEvent();
}

class GetComedyMovies extends ComedyMovieEvent {
  @override
  List<Object> get props => [];
}
