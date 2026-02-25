import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/region_api/region_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/region_api/region_modal.dart';

/// Region Getx Controller ///
class RegionController extends GetxController {
  var isLoading = true.obs;
  var regionList = <Region>[].obs;

  @override
  void onInit() {
    fetchRegion();
    super.onInit();
  }

  void fetchRegion() async {
    try {
      isLoading(true);
      var region = await RegionProvider.region();
      regionList.value = region.region!;
    } finally {
      isLoading(false);
    }
  }
}
