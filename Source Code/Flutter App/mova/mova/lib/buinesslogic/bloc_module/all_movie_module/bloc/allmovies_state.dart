part of 'allmovies_bloc.dart';

abstract class AllMoviesState extends Equatable {
  const AllMoviesState();
  List<Object> get props => [];
}

class AllMoviesInitial extends AllMoviesState {}

class AllMoviesLoading extends AllMoviesState {}

class AllMoviesLoaded extends AllMoviesState {
  final MovieModal movieModal;
  const AllMoviesLoaded(this.movieModal);
  @override
  List<Object> get props => [MovieModal];
}

class AllMoviesError extends AllMoviesState {}
