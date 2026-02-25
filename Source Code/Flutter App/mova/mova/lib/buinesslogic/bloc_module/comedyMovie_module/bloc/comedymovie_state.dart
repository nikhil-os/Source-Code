part of 'comedymovie_bloc.dart';

@immutable
abstract class ComedymovieState extends Equatable{
  const ComedymovieState();

  List<Object> get props => [];
}

class ComedymovieInitial extends ComedymovieState {}


class ComedymovieLoading extends ComedymovieState {}

class ComedymovieLoaded extends ComedymovieState {
  final HomeMovieModal movieModal;
  const ComedymovieLoaded(this.movieModal);

  @override
  List<Object> get props => [movieModal];
}

class ComedymovieError extends ComedymovieState {}