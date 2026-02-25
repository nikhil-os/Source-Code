// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:webtime_movie_ocean/googleAd/google_video_ad.dart';
// import 'package:video_player/video_player.dart';
//
// /// Video Getx Controller ///
// class VideoController extends GetxController {
//   late VideoPlayerController videoPlayerController;
//   var position = Duration.zero;
//
//   Future<void> updateSeeker() async {
//     final newPosition = await videoPlayerController.position;
//     position = newPosition!;
//     update();
//     update(["duration"]);
//   }
//
//   String getPosition() {
//     final duration = Duration(milliseconds: videoPlayerController.value.position.inMilliseconds.round());
//     return [duration.inMinutes, duration.inSeconds].map((e) => e.remainder(60).toString().padLeft(2, "0")).join(":");
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//     videoPlayerController.dispose();
//     VideoAdServices.dispose();
//   }
//
//   setVolume() {
//     videoPlayerController.value.volume == 0 ? videoPlayerController.setVolume(1.0) : videoPlayerController.setVolume(0.0);
//     update();
//   }
//
//   setTenSecondsPrevious() async {
//     await videoPlayerController.seekTo(
//       (await videoPlayerController.position)! - const Duration(seconds: 10),
//     );
//     update();
//   }
//
//   setTenMinutePrevious() async {
//     await videoPlayerController.seekTo(
//       (await videoPlayerController.position)! - const Duration(minutes: 1),
//     );
//     update();
//   }
//
//   setTenSecondsNext() async {
//     await videoPlayerController.seekTo(
//       (await videoPlayerController.position)! + const Duration(seconds: 10),
//     );
//     update();
//   }
//
//   setTenMinuteNext() async {
//     await videoPlayerController.seekTo(
//       (await videoPlayerController.position)! + const Duration(minutes: 1),
//     );
//     update();
//   }
//
//   setVideo() {
//     videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
//     update();
//   }
// }

import 'dart:async';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/googleAd/google_video_ad.dart';
import 'package:video_player/video_player.dart';

/// Video Getx Controller ///
class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  var position = Duration.zero;

  /// Called by your Timer.periodic in the widget.
  /// Use the synchronous value.position (never null) instead of the async
  /// Future<Duration?> getter that may be null before init.
  void updateSeeker() {
    if (!videoPlayerController.value.isInitialized) return;
    position = videoPlayerController.value.position;
    update();
    update(["duration"]);
  }

  /// "MM:SS" or "H:MM:SS" formatting from the current value.position.
  String getPosition() {
    final d = videoPlayerController.value.position;
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  @override
  void onClose() {
    super.onClose();
    // Only dispose here if you're not disposing it elsewhere.
    // Your widget calls videoController.dispose(), so this is fine.
    videoPlayerController.dispose();
    VideoAdServices.dispose();
  }

  void setVolume() {
    final v = videoPlayerController.value.volume;
    videoPlayerController.setVolume(v == 0 ? 1.0 : 0.0);
    update();
  }

  Future<void> setTenSecondsPrevious() async {
    if (!videoPlayerController.value.isInitialized) return;
    final current = videoPlayerController.value.position;
    final target = current - const Duration(seconds: 10);
    await videoPlayerController.seekTo(target < Duration.zero ? Duration.zero : target);
    update();
  }

  Future<void> setTenMinutePrevious() async {
    if (!videoPlayerController.value.isInitialized) return;
    final current = videoPlayerController.value.position;
    final target = current - const Duration(minutes: 1);
    await videoPlayerController.seekTo(target < Duration.zero ? Duration.zero : target);
    update();
  }

  Future<void> setTenSecondsNext() async {
    if (!videoPlayerController.value.isInitialized) return;
    final current = videoPlayerController.value.position;
    final total = videoPlayerController.value.duration;
    final target = current + const Duration(seconds: 10);
    await videoPlayerController.seekTo(
      (total != null && target > total) ? total : target,
    );
    update();
  }

  Future<void> setTenMinuteNext() async {
    if (!videoPlayerController.value.isInitialized) return;
    final current = videoPlayerController.value.position;
    final total = videoPlayerController.value.duration;
    final target = current + const Duration(minutes: 1);
    await videoPlayerController.seekTo(
      (total != null && target > total) ? total : target,
    );
    update();
  }

  void setVideo() {
    if (!videoPlayerController.value.isInitialized) return;
    videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
    update();
  }
}
