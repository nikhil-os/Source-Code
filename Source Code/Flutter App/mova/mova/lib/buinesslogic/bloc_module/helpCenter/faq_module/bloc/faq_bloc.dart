
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/faq_module/faq_resources/faq_repository.dart';
import 'package:webtime_movie_ocean/customModal/faq_modal.dart';

part 'faq_event.dart';

part 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FAQState> {
  final FAQRepository _faqRepository;

  FaqBloc(this._faqRepository) : super(FAQInitial()) {
    on<FaqEvent>((event, emit) async {
      emit(FAQLoading());
      final faqList = await _faqRepository.faq();
      emit(FAQLoaded(faqList));
    });
  }
}
