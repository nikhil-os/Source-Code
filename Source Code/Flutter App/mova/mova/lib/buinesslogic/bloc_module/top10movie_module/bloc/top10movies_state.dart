part of 'top10movies_bloc.dart';

@immutable
abstract class Top10moviesState extends Equatable {
  const Top10moviesState();

  List<Object> get props => [];
}

class Top10moviesInitial extends Top10moviesState {}

class Top10moviesLoading extends Top10moviesState {}

class Top10moviesLoaded extends Top10moviesState {
  final HomeMovieModal movieModal;
  const Top10moviesLoaded(this.movieModal);

  @override
  List<Object> get props => [movieModal];
}

class Top10moviesError extends Top10moviesState {}
