import 'dart:io';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

class AdHelper {
  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return interstitialAd ?? "";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String? get nativeAdUnitId {
    if (Platform.isAndroid) {
      return nativeAd ?? "";
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return bannerAd ?? "";
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

// static String get rewardedAdUnitId {
//   if (Platform.isAndroid) {
//     return "ca-app-pub-3940256099942544/5224354917";
//   } else if (Platform.isIOS) {
//     return "ca-app-pub-3940256099942544/1712485313";
//   } else {
//     throw new UnsupportedError("Unsupported platform");
//   }
// }
}
