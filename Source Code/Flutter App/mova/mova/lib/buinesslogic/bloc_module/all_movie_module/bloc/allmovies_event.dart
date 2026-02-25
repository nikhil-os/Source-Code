part of 'allmovies_bloc.dart';

abstract class AllMoviesEvent extends Equatable {
  const AllMoviesEvent();
}

class GetAllMovie extends AllMoviesEvent {
  @override
  List<Object> get props => [];
}
