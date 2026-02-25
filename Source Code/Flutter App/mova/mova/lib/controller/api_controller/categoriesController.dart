import 'package:get/get.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/Categories_api/categories_api_controller.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/Categories_api/categories_modal.dart';

/// Categories Getx Controller ///
class CategoriesController extends GetxController {
  var isLoading = true.obs;
  var categoriesList = <Category>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      var categories = await CategoriesProvider.categories();
      categoriesList.value = (categories.category ?? []).cast<Category>();
    } finally {
      isLoading(false);
    }
  }
}
