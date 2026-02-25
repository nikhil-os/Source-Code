import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/contactUs_module/contactUs_resources/contactUs_provider.dart';
import 'package:webtime_movie_ocean/customModal/contactUs_modal.dart';

class ContactUsRepository {
  final _provider = GetContactus();

  Future<ContactUsModal> contactUs() {
    return _provider.contactUs();
  }
}