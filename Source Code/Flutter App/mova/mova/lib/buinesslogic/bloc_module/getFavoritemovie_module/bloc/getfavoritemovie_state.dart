part of 'getfavoritemovie_bloc.dart';

@immutable
abstract class GetfavoritemovieState  extends Equatable{
  List<Object> get props => [];
}

class GetfavoritemovieInitial extends GetfavoritemovieState {}


class GetfavoritemovieLoading extends GetfavoritemovieState {}
class GetfavoritemovieLoaded extends GetfavoritemovieState {
  final GetFavoriteListMovieModal movieModal;
   GetfavoritemovieLoaded(this.movieModal);
  @override
  List<Object> get props => [movieModal];
}


class GetfavoritemovieError extends GetfavoritemovieState {

}
