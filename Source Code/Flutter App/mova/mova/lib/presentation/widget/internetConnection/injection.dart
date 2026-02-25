import 'package:get/get.dart';
import 'package:webtime_movie_ocean/presentation/widget/internetConnection/check_internet.dart';

class DependencyInjection {
  static void init() async {
    //services
    Get.put<NetworkStatusService>(NetworkStatusService(), permanent: true);
  }
}
