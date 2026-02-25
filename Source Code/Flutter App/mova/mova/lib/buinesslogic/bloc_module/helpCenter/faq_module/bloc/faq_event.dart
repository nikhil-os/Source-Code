part of 'faq_bloc.dart';

@immutable
abstract class FaqEvent  extends Equatable{
  FaqEvent();
}
class GetFAQ extends FaqEvent{
  @override
  List<Object> get props => [];
}