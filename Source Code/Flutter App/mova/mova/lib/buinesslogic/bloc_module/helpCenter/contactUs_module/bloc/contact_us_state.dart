part of 'contact_us_bloc.dart';

@immutable
abstract class ContactUsState {
  ContactUsState();
  List<Object> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsLoaded extends ContactUsState {
  final ContactUsModal movieModal;
   ContactUsLoaded(this.movieModal);

  @override
  List<Object> get props => [movieModal];
}

class ContactUsError extends ContactUsState {}
