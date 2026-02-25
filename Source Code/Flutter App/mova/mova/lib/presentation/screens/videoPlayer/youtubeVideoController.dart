// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Video Getx Controller ///
class YoutubeVideoController extends GetxController {
  late YoutubePlayerController youtubePlayerController;
  var position = Duration.zero;
  Future<void> updateSeeker() async {
    final newPosition = youtubePlayerController.value.position;
    position = newPosition;
    update();
  }

  String getPosition() {
    final duration = Duration(milliseconds: youtubePlayerController.value.position.inMilliseconds.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((e) => e.remainder(60).toString().padLeft(2, "0"))
        .join(":");
  }

  @override
  void onClose() {
    super.onClose();
    youtubePlayerController.dispose();
  }

  setVolume() {
    youtubePlayerController.value.volume == 100
        ? youtubePlayerController.setVolume(0)
        : youtubePlayerController.setVolume(100);
    update();
  }

  setTenSecondsPrevious() async {
    youtubePlayerController.seekTo(
      (youtubePlayerController.value.position) - const Duration(seconds: 10),
    );
    update();
  }

  setTenMinutePrevious() async {
    youtubePlayerController.seekTo(
      (youtubePlayerController.value.position) - const Duration(minutes: 1),
    );
    update();
  }

  setTenSecondsNext() async {
    youtubePlayerController.seekTo(
      (youtubePlayerController.value.position) + const Duration(seconds: 10),
    );
    update();
  }

  setTenMinuteNext() async {
    youtubePlayerController.seekTo(
      (youtubePlayerController.value.position) + const Duration(minutes: 1),
    );
    update();
  }

  setVideo() {
    youtubePlayerController.value.isPlaying ? youtubePlayerController.pause() : youtubePlayerController.play();
    update();
  }
}
