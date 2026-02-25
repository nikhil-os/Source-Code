import 'package:get/get.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/binding/reels_binding.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/view/reels_view.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/tabs_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/creat_profile/Interest_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/creat_profile/creat_profile_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/creat_profile/lets_you_in%20_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/splash_screen.dart';
import 'package:webtime_movie_ocean/presentation/screens/welcome_screen.dart';
import 'package:webtime_movie_ocean/presentation/widget/internetConnection/no_connection_screen.dart';

part "app_routes.dart";

abstract class AppPages {
  static final pages = [
    /// all Pages List ///
    GetPage(
      name: Routes.splash,
      page: SplashScreen.new,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.welcome,
      page: WelcomeScreen.new,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.letsYouIn,
      page: LetsYouInScreen.new,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.interest,
      page: InterestScreen.new,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.fillYourProfile,
      page: FillYourProfileScreen.new,
      transition: Transition.upToDown,
    ),
    GetPage(
      name: Routes.noConnection,
      page: NetworkErrorItem.new,
      transition: Transition.upToDown,
    ),
    GetPage(
      name: Routes.tabs,
      page: TabsScreen.new,
      transition: Transition.upToDown,
    ),
    GetPage(
      name: AppRoutes.reelsPage,
      page: () => const ReelsView(),
      binding: ReelsBinding(),
    ),
  ];
}
