class AppUrls {
  static const BASE_URL =
      "http://66.63.168.107"; // Production VPS server (no port for nginx proxy)
  static const SECRET_KEY = "dev_admin_secret"; // Enter your key like

  static String createUser = "/user/login";
  static String whoLogin = "$BASE_URL/user/profile";
  static String handleNotification = "$BASE_URL/notification/userNotification";
  static String chekUserProfile = "$BASE_URL/user/profile";
  static String updateUser = "$BASE_URL/user/update";
  static String top10movies = "$BASE_URL/movie/Top10";
  static String comedyMovie = "$BASE_URL/movie/ComedyMovie";
  static String newReleaseMovie = "$BASE_URL/movie/isNewRelease";
  static String allMovie = "$BASE_URL/movie/getMovie";
  static String movieDetail = "$BASE_URL/movie/detail";
  static String favorite = "/favorite";
  static String isFavorite = "$BASE_URL/favorite/isFavorite";
  static String getFavorite = "$BASE_URL/favorite/favoriteMovie";
  static String categories = "$BASE_URL/category";
  static String region = "$BASE_URL/region";
  static String genre = "$BASE_URL/genre";
  static String adminPanelLiveTv = "$BASE_URL/stream";
  static String year = "$BASE_URL/movie/getYear";
  static String filterWise = "$BASE_URL/movie/filterWise";
  static String download = "$BASE_URL/download/create";
  static String downloadList = "$BASE_URL/download/userWiseDownload";
  static String searchMovie = "$BASE_URL/movie/searchMovieTitle";
  static String premiumPlan = "$BASE_URL/premiumPlan";
  static String premiumPlanCreateHistory =
      "$BASE_URL/premiumPlan/createHistory";
  static String premiumPlanHistory = "$BASE_URL/premiumPlan/history";
  static String addViewToMovie = "$BASE_URL/movie/view";
  static String commentLike = "$BASE_URL/like/create";
  static String getNotification = "$BASE_URL/notification/list";
  static String faq = "$BASE_URL/FAQ";
  static String contactUs = "$BASE_URL/contactUs";
  static String createComments = "$BASE_URL/comment/create";
  static String deleteDownload = "$BASE_URL/download/deleteDownloadMovie";
  static String seasonEpisodes = "$BASE_URL/episode/seasonWiseEpisodeAndroid";
  static String createRating = "/rate/addRating";
  static String getRating = "$BASE_URL/rate";
  static String setting = "$BASE_URL/setting";
  static String topRated = "$BASE_URL/movie/topRated";
  static String advertisement = "$BASE_URL/advertisement";
  static String countryWiseLiveChannels =
      "$BASE_URL/countryLiveTV/getStoredetail";
  static String userComplain = "$BASE_URL/ticketByUser/ticketRaisedByUser";
  static String commentList = "$BASE_URL/comment/getComment";
  static String movieAllLikeThis = "$BASE_URL/movie/allLikeThis";
  static String uploadFile = "/file/upload-file";
  static String userPlanHistory = "/premiumPlan/planHistoryOfUser";
  static String deleteAccount = "$BASE_URL/user/deleteUserAccount";
  static String fetchReels = "/shortVideo/fetchShortVideos";
  static String reelsLikeDislike = "/like/likeOrDislikeOfShortVideo";
  static String videoShare = "/shortVideo/incrementShortVideoShareCount";
  static const userLocationURL = "http://ipss-api.com/json";
}
