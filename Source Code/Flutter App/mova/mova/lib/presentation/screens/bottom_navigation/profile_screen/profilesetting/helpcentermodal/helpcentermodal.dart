// ignore_for_file: non_constant_identifier_names
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';

class HelpModal {
  String tital;
  String icon;

  HelpModal({required this.tital, required this.icon});
}

List<HelpModal> Help = [
  HelpModal(icon: MovixIcon.music, tital: "Customer Service"),
  HelpModal(icon: MovixIcon.whatsApp, tital: "WhatsApp"),
  HelpModal(icon: MovixIcon.website, tital: "Website"),
  HelpModal(icon: MovixIcon.twitter, tital: "Twitter"),
  HelpModal(icon: MovixIcon.instagram, tital: "Instagram"),
];

class FAQmodal {
  bool activ;
  String tital;

  FAQmodal({required this.tital, required this.activ});
}

List<FAQmodal> faqtext = [
  FAQmodal(tital: "General", activ: false),
  FAQmodal(tital: "Account", activ: false),
  FAQmodal(tital: "Service", activ: false),
  FAQmodal(tital: "Video", activ: false),
];
