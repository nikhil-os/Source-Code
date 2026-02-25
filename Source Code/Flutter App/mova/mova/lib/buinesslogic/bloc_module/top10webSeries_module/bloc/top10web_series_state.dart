part of 'top10web_series_bloc.dart';

@immutable
abstract class Top10webSeriesState extends Equatable {
  Top10webSeriesState();

  List<Object> get props => [];
}

class Top10webSeriesInitial extends Top10webSeriesState {}

class Top10webSeriesLoading extends Top10webSeriesState {}

class Top10webSeriesLoaded extends Top10webSeriesState {
  final HomeMovieModal movieModal;

  Top10webSeriesLoaded(this.movieModal);

  @override
  List<Object> get props => [movieModal];
}

class Top10webSeriesError extends Top10webSeriesState {}
