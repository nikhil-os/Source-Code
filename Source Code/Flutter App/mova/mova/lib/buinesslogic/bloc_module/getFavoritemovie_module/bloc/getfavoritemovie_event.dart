part of 'getfavoritemovie_bloc.dart';

@immutable
abstract class GetfavoritemovieEvent extends Equatable{
  GetfavoritemovieEvent();
}

class FavoriteMovie extends GetfavoritemovieEvent{
  @override
  List<Object> get props => [];
}
