part of 'faq_bloc.dart';

@immutable
abstract class FAQState {
  const FAQState();
  List<Object> get props => [];
}

class FAQInitial extends FAQState {}

class FAQLoading extends FAQState {}

class FAQLoaded extends FAQState {
  final FaqModal movieModal;
  FAQLoaded(this.movieModal);

  @override
  List<Object> get props => [movieModal];
}

class FAQError extends FAQState {}
