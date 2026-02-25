part of 'top10web_series_bloc.dart';

@immutable
abstract class Top10webSeriesEvent extends Equatable {
  const Top10webSeriesEvent();
}

class GetTop10WebSeries extends Top10webSeriesEvent {
  @override
  List<Object> get props => [];
}
