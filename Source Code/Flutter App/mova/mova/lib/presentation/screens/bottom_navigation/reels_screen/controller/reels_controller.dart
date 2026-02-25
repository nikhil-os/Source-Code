import 'dart:developer';

import 'package:get/get.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/api/fetch_reels_api.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/reels_screen/model/fetch_reels_model.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:preload_page_view/preload_page_view.dart';

class ReelsController extends GetxController {
  PreloadPageController preloadPageController = PreloadPageController();

  bool isLoadingReels = false;
  FetchReelsModel? fetchReelsModel;

  bool isPaginationLoading = false;

  List<Data> mainReels = [];
  String? currentReels;

  int currentPageIndex = 0;

  RxBool isGlobalMuted = false.obs;
  RxBool isGlobalFullScreen = true.obs;

  int startPagination = -1;
  int limitPagination = 20;

  Future<void> init() async {
    currentPageIndex = 0;
    mainReels.clear();
    startPagination = -1;
    isLoadingReels = true;
    update(["onGetReels"]);
    await onGetReels();
    isLoadingReels = false;
  }

  void onPagination(int value) async {
    if ((mainReels.length - 1) == value) {
      if (isPaginationLoading == false) {
        isPaginationLoading = true;
        update(["onPagination"]);
        await onGetReels();
        isPaginationLoading = false;
        update(["onPagination"]);
      }
    }
  }

  void onChangePage(int index) async {
    currentPageIndex = index;
    update(["onChangePage"]);
  }

  Future<void> onGetReels() async {
    fetchReelsModel = null;

    startPagination++;

    fetchReelsModel = await FetchReelsApi.callApi(loginUserId: userId, start: startPagination, limit: limitPagination);

    if (fetchReelsModel?.data != null) {
      if (fetchReelsModel!.data!.isNotEmpty) {
        mainReels.addAll(fetchReelsModel?.data ?? []);

        log("Get Reels mainReels.length => ${mainReels.length}");

        update(["onGetReels"]);
      }
    }
    if (mainReels.isEmpty) {
      update(["onGetReels"]);
    }
  }

  void toggleGlobalMute() {
    isGlobalMuted.value = !isGlobalMuted.value;
  }

  void toggleGlobalFullScreen() {
    isGlobalFullScreen.value = !isGlobalFullScreen.value;
  }

  @override
  void onInit() {
    print('ENTEEEEE :::::');
    onGetReels();
    super.onInit();
  }
}
