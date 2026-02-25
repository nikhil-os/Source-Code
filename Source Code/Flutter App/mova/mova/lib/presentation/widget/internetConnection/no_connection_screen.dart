import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/presentation/screens/bottom_navigation/downlode_screen/download_screen.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/routes/app_pages.dart';
import 'package:webtime_movie_ocean/presentation/widget/internetConnection/check_internet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkErrorItem extends StatefulWidget {
  const NetworkErrorItem({super.key});

  @override
  State<NetworkErrorItem> createState() => _NetworkErrorItemState();
}

class _NetworkErrorItemState extends State<NetworkErrorItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isRetrying = false;
  final NetworkStatusService _networkService = Get.find<NetworkStatusService>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRetry() async {
    setState(() {
      _isRetrying = true;
    });

    try {
      // Check connectivity first
      List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();

      if (connectivityResults.contains(ConnectivityResult.none)) {
        // Still no internet
        _showNoInternetSnackbar();
        setState(() {
          _isRetrying = false;
        });
        return;
      }

      // Check actual internet connection
      bool hasConnection = await DataConnectionChecker().hasConnection;

      if (!hasConnection) {
        _showNoInternetSnackbar();
        setState(() {
          _isRetrying = false;
        });
        return;
      }

      // Internet is available, proceed with authentication check
      SharedPreferences pref = await SharedPreferences.getInstance();

      if (pref.getBool("isLogin") == true) {
        // Try to fetch profile to verify connection and authentication
        final profile = await _networkService.onGetProfile();

        if (profile == null || profile.message == "User does not found.") {
          // User not found or profile fetch failed
          await pref.setBool("isLogin", false);
          Get.offAllNamed(Routes.welcome);
        } else {
          // Profile fetched successfully, go to main app
          setState(() {
            checkInternet = true;
            pref.setBool("checkInternet", true);
            checkInternet = pref.getBool("checkInternet")!;
          });
          Get.offAllNamed(Routes.tabs);
        }
      } else {
        // User not logged in, go to welcome screen
        Get.offAllNamed(Routes.welcome);
      }
    } catch (e) {
      log('Error in retry: $e');
      _showErrorSnackbar();
    } finally {
      setState(() {
        _isRetrying = false;
      });
    }
  }

  void _showNoInternetSnackbar() {
    Fluttertoast.showToast(
      msg: "No Internet Please try again.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorValues.redColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorSnackbar() {
    Fluttertoast.showToast(
      msg: "Something went wrong. Please try again.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorValues.redColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _goToDownloads() async {
    setState(() {
      _isRetrying = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin") == true) {
      setState(() {
        checkInternet = true;
        pref.setBool("checkInternet", true);
        checkInternet = pref.getBool("checkInternet")!;
      });
    }

    setState(() {
      _isRetrying = false;
    });

    Get.offAll(() => const DownloadTab());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = getStorage.read('isDarkMode') == true;

    return Scaffold(
      backgroundColor: isDarkMode ? ColorValues.blackColor : ColorValues.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated WiFi Off Icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: (isDarkMode ? ColorValues.grayColor.withValues(alpha: 0.2) : ColorValues.grayColor.withValues(alpha: 0.1)),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wifi_off_rounded,
                        size: 80,
                        color: ColorValues.grayColor,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Main Title
              Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? ColorValues.whiteColor : ColorValues.blackColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Subtitle
              const Text(
                'Please check your internet connection\nand try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorValues.grayColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Retry Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorValues.redColor,
                    foregroundColor: ColorValues.whiteColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isRetrying ? null : _handleRetry,
                  child: _isRetrying
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorValues.whiteColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Checking Connection...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Try Again',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Go to Downloads Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDarkMode ? ColorValues.whiteColor : ColorValues.blackColor,
                    side: BorderSide(
                      color: ColorValues.grayColor.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isRetrying ? null : _goToDownloads,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Go to Downloads',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Help Text
              const Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  'You can still access your downloaded content offline',
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorValues.grayColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
