import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:interactive_media_ads/interactive_media_ads.dart';

class VideoAdServices {
  static bool isLoadingVideoAd = false;
  static bool isAdReady = false;
  static bool isAdPlaying = false;
  static bool isAdCompleted = false;

  static AdDisplayContainer? adDisplayContainer;
  static AdsManager? _adsManager;
  static AdsLoader? _adsLoader;
  static bool _isInitialized = false;

  static VoidCallback? onAdCompleted;
  static VoidCallback? onAdStarted;
  static VoidCallback? onAdFailed;

  static void initialize({
    VoidCallback? onAdCompletedCallback,
    VoidCallback? onAdStartedCallback,
    VoidCallback? onAdFailedCallback,
  }) {
    if (_isInitialized) return;

    isLoadingVideoAd = false;
    isAdReady = false;
    isAdPlaying = false;
    isAdCompleted = false;
    adDisplayContainer = null;
    _adsManager = null;
    _adsLoader = null;

    onAdCompleted = onAdCompletedCallback;
    onAdStarted = onAdStartedCallback;
    onAdFailed = onAdFailedCallback;

    _isInitialized = true;
    log("VideoAdServices: Initialized successfully");
  }

  static void dispose() {
    _adsManager?.destroy();
    _adsLoader = null;
    adDisplayContainer = null;
    _adsManager = null;

    isLoadingVideoAd = false;
    isAdReady = false;
    isAdPlaying = false;
    isAdCompleted = false;

    onAdCompleted = null;
    onAdStarted = null;
    onAdFailed = null;
    _isInitialized = false;

    log("VideoAdServices: Disposed successfully");
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

    return AdDisplayContainer(
      onContainerAdded: (AdDisplayContainer container) {
        log('VideoAdServices: AdDisplayContainer added');
        adDisplayContainer = container;
        _loadAds(container);
      },
    );
  }

  static void _loadAds(AdDisplayContainer container) {
    if (isLoadingVideoAd) {
      log('VideoAdServices: Already loading ads, skipping...');
      return;
    }

    isLoadingVideoAd = true;
    isAdReady = false;
    isAdCompleted = false;

    log('VideoAdServices: Starting to load ads...');

    _adsLoader = AdsLoader(
      container: container,
      onAdsLoaded: (OnAdsLoadedData data) {
        log('VideoAdServices: Ads loaded successfully');
        _adsManager = data.manager;
        _setupAdsManager(data.manager);
        isLoadingVideoAd = false;
        isAdReady = true;
      },
      onAdsLoadError: (AdsLoadErrorData data) {
        log('VideoAdServices: Ads load error: ${data.error.message}');
        isLoadingVideoAd = false;
        isAdReady = false;

        // Call onAdFailed callback when ads fail to load
        onAdFailed?.call();

        _handleAdComplete();

        Timer(const Duration(seconds: 3), () {
          log('VideoAdServices: Retrying ad load...');
          _loadAds(container);
        });
      },
    );

    _requestAds();
  }

  static void _setupAdsManager(AdsManager manager) {
    manager.setAdsManagerDelegate(
      AdsManagerDelegate(
        onAdEvent: (AdEvent event) {
          log('VideoAdServices AdEvent: ${event.type}');

          switch (event.type) {
            case AdEventType.loaded:
              log('VideoAdServices: Ad loaded, starting playback');
              isAdPlaying = true;
              manager.start();
              break;

            case AdEventType.started:
              log('VideoAdServices: Ad started playing');
              isAdPlaying = true;
              // Call onAdStarted callback when ad actually starts
              onAdStarted?.call();
              break;

            case AdEventType.allAdsCompleted:
              log('VideoAdServices: All ads completed');
              _handleAdComplete();
              break;

            case AdEventType.clicked:
              log('VideoAdServices: Ad clicked');
              break;

            case AdEventType.complete:
              log('VideoAdServices: Single ad completed');
              break;

            case AdEventType.skipped:
              log('VideoAdServices: Ad skipped');
              _handleAdComplete();
              break;

            default:
              log('VideoAdServices: Unknown ad event: ${event.type}');
          }
        },
        onAdErrorEvent: (AdErrorEvent event) {
          log('VideoAdServices AdError: ${event.error.message}');
          isLoadingVideoAd = false;
          isAdReady = false;
          isAdPlaying = false;

          // Call onAdFailed callback on ad error
          onAdFailed?.call();

          _handleAdComplete();
          _cleanupAdsManager();
        },
      ),
    );

    manager.init(
      settings: AdsRenderingSettings(
        enablePreloading: true,
        playAdsAfterTime: const Duration(microseconds: 0),
      ),
    );
  }

  static void _handleAdComplete() {
    log('VideoAdServices: Handling ad completion');
    isAdPlaying = false;
    isAdCompleted = true;
    onAdCompleted?.call();
    _cleanupAdsManager();
  }

  static Future<void> _requestAds() async {
    if (_adsLoader == null) {
      log('VideoAdServices: AdsLoader is null, cannot request ads');
      return;
    }

    try {
      log('VideoAdServices: Requesting ads from server...');
      await _adsLoader!.requestAds(
        AdsRequest(
          adTagUrl:
              "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_preroll_skippable&sz=640x480&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=",
          contentProgressProvider: ContentProgressProvider(),
        ),
      );
    } catch (e) {
      log('VideoAdServices: Error requesting ads: $e');
      isLoadingVideoAd = false;
      isAdReady = false;

      // Call onAdFailed callback on request error
      onAdFailed?.call();

      _handleAdComplete();
    }
  }

  static void _cleanupAdsManager() {
    _adsManager?.destroy();
    _adsManager = null;
    isAdReady = false;
  }

  static bool get areAdsReady => isAdReady && _adsManager != null;
  static bool get isLoading => isLoadingVideoAd;
  static bool get isPlayingAd => isAdPlaying;
  static bool get hasAdCompleted => isAdCompleted;

  static void playAds() {
    if (areAdsReady) {
      log('VideoAdServices: Starting ad playback');
      isAdPlaying = true;
      _adsManager?.start();
    } else {
      log('VideoAdServices: Ads not ready for playback');
    }
  }

  static void pauseAds() {
    _adsManager?.pause();
    log('VideoAdServices: Ads paused');
  }

  static void resumeAds() {
    _adsManager?.resume();
    log('VideoAdServices: Ads resumed');
  }

  static void skipAd() {
    _adsManager?.skip();
    log('VideoAdServices: Ad skipped');
  }
}
