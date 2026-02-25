import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/chekuser_api/fetch_profile_model.dart';

class Database {
  static final localStorage = GetStorage();

  static FetchProfileModel? fetchProfileModel;

  static RxString profileImage = "".obs;

  static String? onGetNetworkUrl(String id) => localStorage.read(id);
  static onSetNetworkUrl({required String id, required String image}) async => await localStorage.write(id, image);
}
