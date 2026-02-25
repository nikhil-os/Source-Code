import 'package:flutter/material.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/utils/theme/theme.dart';

class SeeAllContainer extends StatelessWidget {
  const SeeAllContainer({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(42),
          color: (getStorage.read('isDarkMode') == true) ? ColorValues.containerBg : Colors.grey.shade200,
        ),
        child: Text(
          'View All',
          style: seeAllStyle,
        ),
      ),
    );
  }
}
