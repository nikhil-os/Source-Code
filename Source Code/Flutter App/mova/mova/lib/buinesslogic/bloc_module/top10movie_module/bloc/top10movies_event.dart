part of 'top10movies_bloc.dart';


@immutable
abstract class Top10moviesEvent extends Equatable  {
  const Top10moviesEvent();


}

class GetTop10Movies extends Top10moviesEvent{
  @override
  List<Object> get props => [];
}