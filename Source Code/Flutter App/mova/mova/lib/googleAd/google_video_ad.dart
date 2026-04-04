import 'package:flutter/material.dart';

class VideoAdServices {
  static bool isLoadingVideoAd = false;
  static bool isAdReady = false;
  static bool isAdPlaying = false;
  static bool isAdCompleted = false;

  static VoidCallback? onAdCompleted;
  static VoidCallback? onAdStarted;
  static VoidCallback? onAdFailed;

  static void initialize({
    VoidCallback? onAdCompletedCallback,
    VoidCallback? onAdStartedCallback,
    VoidCallback? onAdFailedCallback,
  }) {
    onAdCompleted = onAdCompletedCallback;
    onAdStarted = onAdStartedCallback;
    onAdFailed = onAdFailedCallback;

    isLoadingVideoAd = false;
    isAdReady = false;
    isAdPlaying = false;
    isAdCompleted = false;
  }

  static void dispose() {
    isLoadingVideoAd = false;
    isAdReady = false;
    isAdPlaying = false;
    isAdCompleted = false;

    onAdCompleted = null;
    onAdStarted = null;
    onAdFailed = null;
  }

  static Widget createAdWidget({
    VoidCallback? onAdCompletedCallback,
    VoidCallback? onAdStartedCallback,
    VoidCallback? onAdFailedCallback,
  }) {
    initialize(
      onAdCompletedCallback: onAdCompletedCallback,
      onAdStartedCallback: onAdStartedCallback,
      onAdFailedCallback: onAdFailedCallback,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isAdCompleted = true;
      onAdCompleted?.call();
    });

    return const SizedBox.shrink();
  }

  static bool get areAdsReady => false;
  static bool get isLoading => isLoadingVideoAd;
  static bool get isPlayingAd => isAdPlaying;
  static bool get hasAdCompleted => isAdCompleted;

  static void playAds() {}

  static void pauseAds() {}

  static void resumeAds() {}

  static void skipAd() {}
}
