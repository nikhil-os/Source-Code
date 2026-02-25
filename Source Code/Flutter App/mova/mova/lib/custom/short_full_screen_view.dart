import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_images.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';

import '../presentation/widget/size_configuration.dart';

class ShortFullScreenView extends StatelessWidget {
  const ShortFullScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              ProfileAssetValues.shortFullScreenView,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Top-left back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: (getStorage.read('isDarkMode') == true)
                      ? ColorValues.darkModeThird.withValues(alpha: 0.35)
                      : ColorValues.darkModeThird.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    MovixIcon.backArrowIcon,
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.whiteColor,
                  ),
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),

          // Bottom content
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie details
                Row(
                  children: [
                    // Thumbnail
                    Container(
                      height: 60,
                      width: 60,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: ColorValues.whiteColor)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            ProfileAssetValues.shortImage1,
                            fit: BoxFit.cover,
                          )),
                    ),
                    const SizedBox(width: 8),
                    // Text info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "The Family",
                          style: GoogleFonts.outfit(
                            color: ColorValues.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Most Popular Web Series",
                          style: GoogleFonts.outfit(color: ColorValues.whiteText, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  "It is a long established fact that a reader\nwill be distracted by the readable content looking...",
                  style: GoogleFonts.outfit(color: ColorValues.whiteText, fontSize: 12),
                ),
                const SizedBox(height: 20),
                // Watch Button
                Center(
                    child: Container(
                  height: SizeConfig.screenHeight / 15,
                  width: double.infinity,
                  decoration: BoxDecoration(color: ColorValues.redColor, borderRadius: BorderRadius.circular(60)),
                  child: Center(
                      child: Text(
                    StringValue.watchFullMovie.tr,
                    style: GoogleFonts.outfit(
                      color: ColorValues.whiteColor,
                      fontSize: 18,
                    ),
                  )),
                )),
              ],
            ),
          ),

          // Right icons
          Positioned(
            right: 12,
            bottom: SizeConfig.screenHeight / 8,
            child: Column(
              children: [
                _buildIconButton(
                  icon: SvgPicture.asset(
                    MovixIcon.whiteFavouriteIcon,
                    height: 20,
                    width: 20,
                    color: ColorValues.whiteColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildIconButton(
                  icon: SvgPicture.asset(
                    MovixIcon.shareIcon,
                    height: 20,
                    width: 20,
                    color: ColorValues.whiteColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildIconButton(
                  icon: SvgPicture.asset(
                    MovixIcon.fullScreenViewIcon,
                    height: 20,
                    width: 20,
                    color: ColorValues.whiteColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildIconButton(
                  icon: SvgPicture.asset(
                    MovixIcon.whiteSpeakerIcon,
                    height: 20,
                    width: 20,
                    color: ColorValues.whiteColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildIconButton(
                    icon: const Icon(
                  Icons.more_horiz,
                  color: ColorValues.whiteColor,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required Widget icon}) {
    return CircleAvatar(
      backgroundColor: ColorValues.whiteColor.withValues(alpha: 0.1),
      child: icon,
    );
  }
}
