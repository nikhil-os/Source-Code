import 'package:flutter/widgets.dart';

class InitializationStatus {}

class MobileAds {
  MobileAds._();

  static final MobileAds instance = MobileAds._();

  Future<InitializationStatus> initialize() async => InitializationStatus();
}

class Ad {
  void dispose() {}
}

class AdRequest {
  const AdRequest();
}

class AdSize {
  final int width;
  final int height;

  const AdSize(this.width, this.height);

  static const banner = AdSize(320, 50);
}

class LoadAdError {
  final int code;
  final String message;

  const LoadAdError({this.code = 0, this.message = ''});
}

class AdError {
  final int code;
  final String message;

  const AdError({this.code = 0, this.message = ''});
}

class BannerAdListener {
  final void Function(Ad ad)? onAdLoaded;
  final void Function(Ad ad, LoadAdError error)? onAdFailedToLoad;

  const BannerAdListener({
    this.onAdLoaded,
    this.onAdFailedToLoad,
  });
}

class NativeAdListener {
  final void Function(Ad ad)? onAdLoaded;
  final void Function(Ad ad, LoadAdError error)? onAdFailedToLoad;

  const NativeAdListener({
    this.onAdLoaded,
    this.onAdFailedToLoad,
  });
}

class FullScreenContentCallback {
  final void Function(Ad ad)? onAdDismissedFullScreenContent;

  const FullScreenContentCallback({
    this.onAdDismissedFullScreenContent,
  });
}

class InterstitialAdLoadCallback {
  final void Function(InterstitialAd ad) onAdLoaded;
  final void Function(LoadAdError error) onAdFailedToLoad;

  const InterstitialAdLoadCallback({
    required this.onAdLoaded,
    required this.onAdFailedToLoad,
  });
}

class BannerAd extends Ad {
  final String adUnitId;
  final AdRequest request;
  final AdSize size;
  final BannerAdListener? listener;

  BannerAd({
    required this.adUnitId,
    required this.request,
    required this.size,
    this.listener,
  });

  void load() {
    listener?.onAdLoaded?.call(this);
  }
}

class NativeAd extends Ad {
  final String adUnitId;
  final String? factoryId;
  final AdRequest request;
  final NativeAdListener? listener;

  NativeAd({
    required this.adUnitId,
    this.factoryId,
    required this.request,
    this.listener,
  });

  void load() {
    listener?.onAdLoaded?.call(this);
  }
}

class InterstitialAd extends Ad {
  FullScreenContentCallback? fullScreenContentCallback;

  static void load({
    required String adUnitId,
    required AdRequest request,
    required InterstitialAdLoadCallback adLoadCallback,
  }) {
    adLoadCallback.onAdLoaded(InterstitialAd());
  }

  void show() {
    fullScreenContentCallback?.onAdDismissedFullScreenContent?.call(this);
  }
}

class AdWidget extends StatelessWidget {
  final Ad ad;

  const AdWidget({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
