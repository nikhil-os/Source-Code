import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/premiumPlan_api/premium_plan_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/premiumPlan_api/premium_plan_modal.dart';

class PlanController extends GetxController {
  var isLoading = true.obs;
  var planList = <PremiumPlan>[].obs;
  final currentIndex = 0.obs;
  final PageController pageController = PageController();

  @override
  void onInit() {
    fetchPlan();
    super.onInit();
  }

  void fetchPlan() async {
    try {
      isLoading(true);
      var plan = await PremiumPlanProvider.premiumPlanController();
      planList.value = plan.premiumPlan!;
      currentIndex.value = 0;
    } finally {
      isLoading(false);
    }
  }

  void animateToSlide(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
