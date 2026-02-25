import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/faq_module/faq_resources/faq_provider.dart';
import 'package:webtime_movie_ocean/customModal/faq_modal.dart';

class FAQRepository {
  final _provider = FAQ();

  Future<FaqModal> faq() {
    return _provider.faq();
  }
}