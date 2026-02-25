import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:video_player/video_player.dart';

class VideoScreenController extends GetxController {
  final RxBool isAdCompleted = false.obs;

  late VideoPlayerController videoPlayerController;

  @override
  void onInit() {
    super.onInit();

    // Initialize video player (keep paused initially)
    videoPlayerController = VideoPlayerController.network("https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4")
      ..initialize().then((_) {
        update();
      });
  }

  void onAdCompletedCallback() {
    isAdCompleted.value = true;
    videoPlayerController.play(); // start video after ad
  }

  void onAdStartedCallback() {
    // You can pause video or do something else if needed
  }

  void onAdFailedCallback() {
    isAdCompleted.value = true; // continue to video if ad fails
    videoPlayerController.play();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
