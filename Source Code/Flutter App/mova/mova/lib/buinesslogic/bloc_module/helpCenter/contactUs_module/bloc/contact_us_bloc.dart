import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/contactUs_module/contactUs_resources/contactUs_repository.dart';
import 'package:webtime_movie_ocean/customModal/contactUs_modal.dart';

part 'contact_us_event.dart';
part 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  final ContactUsRepository _contactUsRepository;

  ContactUsBloc(this._contactUsRepository) : super(ContactUsInitial()) {
    on<ContactUsEvent>((event, emit) async  {
      emit(ContactUsLoading());
      final contactUsList = await _contactUsRepository.contactUs();
      emit(ContactUsLoaded(contactUsList));
    });
  }
}
