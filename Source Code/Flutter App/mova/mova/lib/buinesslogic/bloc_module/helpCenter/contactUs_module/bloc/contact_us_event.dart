part of 'contact_us_bloc.dart';

@immutable
abstract class ContactUsEvent extends Equatable {
  const ContactUsEvent();
}
class ContactUs extends ContactUsEvent{
  @override
  List<Object> get props => [];
}
