import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';

class DownloadProgressDialog extends StatelessWidget {
  final double? progress;
  final double? downloadedMB;
  final double? totalMB;
  final VoidCallback? onHide;

  const DownloadProgressDialog({
    super.key,
    this.progress,
    this.downloadedMB,
    this.totalMB,
    this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Download',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: ColorValues.redColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Movies still downloading...\nPlease wait or hide the process',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.white70, fontWeight: FontWeight.w400, fontSize: 14),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: ColorValues.redColor,
            ),
          ],
        ),
      ),
    );
  }
}
