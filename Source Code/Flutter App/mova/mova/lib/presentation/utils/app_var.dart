// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webtime_movie_ocean/buinesslogic/apiservice/creatDownliad_api/download_movie_list_modal.dart';

/// App All Variables ///
final getStorage = GetStorage();

enum ImageSourceType { gallery }

File? updateProfileImage;
File? ComplainImage;
int selectedIndex = 0;
String? deviceId;
String? fcmToken;
bool showAdminPannelLiveChannels = false;
String? identity;
String SECRET_KEY = "";
String razorPaySecretKey = "";
String stripePublishableKey = "";
String flutterWaveId = "";
bool isFlutterWave = false;
bool isStripe = false;
bool isRazorpay = false;
bool isGooglePlaySwitch = false;
bool isAppSetting = false;
String password = "";
String email = "";
List Faqdata = [];
String name = "";
String image = "";
String gender = "";
String country = "";
String userId = "";
double rating = 0;
List<String> yourInterest = [];
List<String> type = ["movie", "tv"];
List<String> selectedType = [];
List<String> Regions = [];
List<String> Genres = [];
List<String> year = [];
Map updateuser = {};
Map AllMovieData = {};
Map AllMovieDetails = {};
List<Download> download = [];
Map DownloadData = {};
int? DownloadDatalenth;
Map likeData = {};
bool notification1 = true;
bool notification4 = true;
bool notification5 = true;
bool notification6 = false;
String userEmail = "";
String userEmail2 = "";
String userNickName = "";
String nickName = "";
String userNickName2 = "";
String userName = "";
String userName2 = "";
String userGender = "";
String userGender2 = "";
String userCountry = "";
String userImage = "";
String userCountry2 = "";
int loginType = 0;
bool isMovieFavorite = false;
bool isWatchingMovie = false;
bool indicator = true;
bool enabled = true;
bool userBlock = false;
bool checkInternet = false;
bool isPremiumPlan = false;
bool isProfile = false;
String UniqueId = "";
int planValue = 0;
List<String> youtubeKey = [];
var key = "";
String userLiveCountry = "";
bool isMovieDownload = false;
// List<String> isMovieDownloaded = [];

RxList<String> downloadedMovie = <String>[].obs;

RxBool videoDownload = false.obs;
RxBool serverSeriesDownload = false.obs;
RxBool serverWebDownload = false.obs;
RxBool serverVideo = false.obs;

bool isFavoriteProcessing = false;

// String userProfileImage = "https://cdn.pixabay.com/photo/2020/12/02/01/06/chipmunk-5795916_960_720.jpg";
String userProfileImage =
    "https://cdn-icons-png.flaticon.com/512/2202/2202112.png";

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController nickNameController = TextEditingController();
TextEditingController countryController = TextEditingController();

/// new added variable

bool on = false;
File? ComplainImage2;

String? selectedValue;
String? selectedCountryValue;
String? nativeAd;
String? interstitialAd;
String? bannerAd;
String? privacyPolicy;
String? termConditionLink;

String keyNames = "";
String folderStructures = "";
String latestimage = "";

class temp {
  static bool general = true;
  static bool release = true;
  static bool appupdate = true;
  static bool subscription = true;
}

int bottomBarSize = Platform.isAndroid ? 65 : 80;
