import 'package:get/get.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/controller/reels_controller.dart';

class ReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsController>(() => ReelsController());
  }
}
