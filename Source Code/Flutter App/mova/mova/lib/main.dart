import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/addViewToMovie/add_view_to_movie_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/createComments_api/createComments_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/delete_download_api/delete_download_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/rating_api/create_rating_api/create_rating_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/rating_api/get_rating_api/get_rating_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/all_movie_module/Allmovi_resources/Allmovies_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/contactUs_module/contactUs_resources/contactUs_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/helpCenter/faq_module/faq_resources/faq_repository.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/top10webSeries_module/top10webSeries_resources/top10webSeries_repository.dart';
import 'package:webtime_movie_ocean/customModal/themeServic.dart';
import 'package:webtime_movie_ocean/localization/locale_constant.dart';
import 'package:webtime_movie_ocean/localization/localizations_delegate.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/platform_device_id.dart';
import 'package:webtime_movie_ocean/presentation/utils/routes/app_pages.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/themdata.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'buinesslogic/apiservice/chekuser_api/fetch_profile_provider.dart';
import 'buinesslogic/apiservice/commentLike_api/commentLike_api_controller.dart';
import 'buinesslogic/apiservice/complain_api/controller/complent_controller.dart';
import 'buinesslogic/apiservice/creatDownliad_api/creat_download_controller.dart';
import 'buinesslogic/apiservice/createFavoriteMovie_api/create_favourite_movie_api_controller.dart';
import 'buinesslogic/apiservice/filterWise_api/filter_wise_controller.dart';
import 'buinesslogic/apiservice/getFavoriteListMovie_api/get_favorite_list_movie_api_controller.dart';
import 'buinesslogic/apiservice/notification_api/getNotification_api_controller.dart';
import 'buinesslogic/apiservice/premiumPlanhistory_api/premiumPlanhistory_controller.dart';
import 'buinesslogic/apiservice/update_user/update_user_controller.dart';
import 'buinesslogic/auth/login_helper.dart';
import 'buinesslogic/bloc_module/comedyMovie_module/comedymovie_resources/comedymovie_repository.dart';
import 'buinesslogic/bloc_module/getFavoritemovie_module/getfavoritemovie_resources/getfavoritemovie_repository.dart';
import 'buinesslogic/bloc_module/newreleasemovie_module/newReleaseMovie_resources/newReleaseMovie_repository.dart';
import 'buinesslogic/bloc_module/top10movie_module/top10movies_resources/top10movies_repository.dart';
import 'presentation/screens/bottom_navigation/downlode_screen/download_history.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await GetStorage.init();

  final box = GetStorage();
  if (box.read('selected_language') == null) {
    box.write('selected_language', 'English (English)');
  }
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  /// SharedPreferences instance ///
  SharedPreferences pref = await SharedPreferences.getInstance();

  DownloadHistory.onGet(); // Get Downloads....

  /// Download Movie ///
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );

  /// Firebase initialize ///
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  /// Allow google_fonts to fetch from network (prevents AssetManifest crash) ///
  GoogleFonts.config.allowRuntimeFetching = true;

  /// identity ///
  identity = (await PlatformDeviceId.getDeviceId)!;
  print('Running on $identity');
  userId = pref.getString("userId") ?? "";
  log("UserId :: $userId");
  userEmail = pref.getString("userEmail") ?? "";
  userEmail2 = pref.getString("userEmail2") ?? "";
  userNickName2 = pref.getString("userNickName2") ?? "NickName";
  userName2 = pref.getString("userName2") ?? "Name";
  userGender2 = pref.getString("userGender2") ?? "Gender";
  userCountry2 = pref.getString("userCountry2") ?? "Country";
  loginType = pref.getInt("loginType") ?? 0;
  isMovieFavorite = pref.getBool("isMovieFavorite") ?? false;
  isPremiumPlan = pref.getBool("isPremiumPlan") ?? false;
  isMovieDownload = pref.getBool("isMovieDownload") ?? false;
  downloadedMovie.value = pref.getStringList("DownloadList") ?? [];

  log("New Updated Download List ::: ${downloadedMovie.value}");
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
    return true;
  };
  userProfileImage = pref.getString('userProfileImage') ??
      "https://cdn.pixabay.com/photo/2020/12/02/01/06/chipmunk-5795916_960_720.jpg";
  print(userId);
  runApp(
    const WebTimeApp(),
  );
}

InAppPurchase inAppPurchase = InAppPurchase.instance;
late StreamSubscription<dynamic> streamSubscription;
List<ProductDetails> products = [];
const variant = {"Variant1", "Variant2"};

class WebTimeApp extends StatefulWidget {
  const WebTimeApp({super.key});

  static final StreamController purchaseStreamController =
      StreamController<PurchaseDetails>.broadcast();

  @override
  State<WebTimeApp> createState() => _WebTimeAppState();
}

class _WebTimeAppState extends State<WebTimeApp> {
  late StreamSubscription streamSubscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    ThemeServices();
    CustomTheme.init();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        log("didChangeDependencies Preference Revoked ${locale.languageCode}");
        log("didChangeDependencies GET LOCALE Revoked ${Get.locale!.languageCode}");
        Get.updateLocale(locale);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeServices = ThemeServices();
    return MultiProvider(
      providers: [
        /// Providers ///
        ChangeNotifierProvider(
          create: (BuildContext context) => UpdateUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => userComplainProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => GoogleSignInController(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => CreateFavoriteMovieProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => GetFavoriteMovieListProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => FilterWiseProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => CreatDownloadProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => FetchProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => AddViewToMovieProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => CommentLikeProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => GetNotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => DeleteDownloadMovieProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => CreateCommentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => premiumPlanhistoryController(),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateRatingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetRatingProvider(),
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          /// Bloc Providers ///
          RepositoryProvider(
            create: (context) => Top10MoviesRepository(),
          ),
          RepositoryProvider(
            create: (context) => NewReleasemovieRepository(),
          ),
          RepositoryProvider(
            create: (context) => AllMoviesRepository(),
          ),
          RepositoryProvider(
            create: (context) => GetFavoriteMovieRepositroy(),
          ),
          RepositoryProvider(
            create: (context) => ComedyMovieRepository(),
          ),
          RepositoryProvider(
            create: (context) => Top10WebSeriesRepository(),
          ),
          RepositoryProvider(
            create: (context) => FAQRepository(),
          ),
          RepositoryProvider(
            create: (context) => ContactUsRepository(),
          ),
        ],
        child: GetMaterialApp(
          /// Dark And Light Theme ///
          theme: Themes.light,
          themeMode: themeServices.theme,
          darkTheme: Themes.dark,
          debugShowCheckedModeBanner: false,
          getPages: AppPages.pages,
          translations: AppLanguages(),
          fallbackLocale: const Locale(LocalizationConstant.languageEn,
              LocalizationConstant.countryCodeEn),
          locale: const Locale("en"),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Container(
                color: (getStorage.read('isDarkMode') == true)
                    ? ColorValues.blackColor
                    : Colors.white,
                child: SafeArea(
                  bottom: Platform.isIOS ? false : true,
                  top: false,
                  left: false,
                  right: false,
                  child: Scaffold(
                    body: Stack(
                      children: [
                        child ?? const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
