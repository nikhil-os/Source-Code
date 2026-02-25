import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/routes/app_pages.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    [
      Permission.storage,
    ].request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              AssetValues.welcome,
              fit: BoxFit.fill,
            ),
          ),
          // Bottom gradient overlay with content
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorValues.blackColor, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 60,
                bottom: bottomPadding + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Welcome title
                  Text(
                    StringValue.welcome.tr,
                    textAlign: TextAlign.center,
                    style: welcomeStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  // Welcome note
                  Text(
                    StringValue.welcomeNote.tr,
                    textAlign: TextAlign.center,
                    style: welcomeNoteStyle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                  // Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed(Routes.letsYouIn);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorValues.shadow2RedColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 8,
                        shadowColor: ColorValues.shadowRedColor,
                      ),
                      child: Text(
                        StringValue.getStart.tr,
                        textAlign: TextAlign.center,
                        style: getStartStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
