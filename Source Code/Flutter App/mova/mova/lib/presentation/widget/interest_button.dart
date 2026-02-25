// ignore_for_file: camel_case_types, must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_var.dart';
import 'package:webtime_movie_ocean/presentation/widget/size_configuration.dart';

class Filter_Controller extends GetxController {
  RxBool choice = RxBool(false);
}

class Filter_Buttons extends StatelessWidget {
  String text;

  Filter_Buttons({super.key, required this.text});
  Filter_Controller controller = Filter_Controller();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Obx(
      () => Container(
        height: SizeConfig.blockSizeVertical * 5.5,
        margin: const EdgeInsets.only(left: 12, bottom: 10),
        child: FilterChip(
          onSelected: (value) {
            if (controller.choice.value) {
              controller.choice.value = false;
              yourInterest.remove(text);
            } else {
              controller.choice.value = true;
              yourInterest.add(text);
            }
          },
          selected: false,
          side: const BorderSide(color: ColorValues.redColor, width: 1.5),
          backgroundColor: (controller.choice.value)
              ? ColorValues.redColor
              : (getStorage.read('isDarkMode') == true)
                  ? ColorValues.darkModeMain
                  : ColorValues.whiteColor,
          label: Padding(
            padding: EdgeInsets.zero,
            child: Text(
              text,
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: (controller.choice.value) ? ColorValues.whiteColor : ColorValues.redColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Filter_Buttons2 extends StatelessWidget {
  String text;
  String id;

  Filter_Buttons2({super.key, required this.text, required this.id});
  Filter_Controller controller = Filter_Controller();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.center,
        child: FilterChip(
          onSelected: (value) {
            if (controller.choice.value) {
              selectedType.remove(text);
              controller.choice.value = false;
            } else {
              selectedType.add(text);
              controller.choice.value = true;
            }
          },
          selected: false,
          side: BorderSide(
              color: (controller.choice.value)
                  ? Colors.transparent
                  : (getStorage.read('isDarkMode') == true)
                      ? ColorValues.detailBorder
                      : ColorValues.darkModeThird.withValues(alpha: 0.10),
              width: 1),
          // padding: const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 10),
          backgroundColor: (controller.choice.value)
              ? ColorValues.blueColor
              : (getStorage.read('isDarkMode') == true)
                  ? ColorValues.detailContainer
                  : ColorValues.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(
            text.capitalizeFirst.toString(),
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: (controller.choice.value) ? ColorValues.whiteColor : ColorValues.grayText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class Filter_Buttons3 extends StatelessWidget {
  String text;
  String id;

  Filter_Buttons3({super.key, required this.text, required this.id});
  Filter_Controller controller = Filter_Controller();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        // height: 42,
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.center,
        child: FilterChip(
          onSelected: (value) {
            if (controller.choice.value) {
              Regions.remove(id);
              controller.choice.value = false;
            } else {
              Regions.add(id);
              controller.choice.value = true;
            }
          },
          selected: false,
          side: BorderSide(
              color: (controller.choice.value)
                  ? Colors.transparent
                  : (getStorage.read('isDarkMode') == true)
                      ? ColorValues.detailBorder
                      : ColorValues.darkModeThird.withValues(alpha: 0.10),
              width: 1),
          // padding: const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 10),
          backgroundColor: (controller.choice.value)
              ? ColorValues.blueColor
              : (getStorage.read('isDarkMode') == true)
                  ? ColorValues.detailContainer
                  : ColorValues.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(
            text.capitalizeFirst.toString(),
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: (controller.choice.value) ? ColorValues.whiteColor : ColorValues.grayText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class Filter_Buttons4 extends StatelessWidget {
  String text;
  String id;

  Filter_Buttons4({super.key, required this.text, required this.id});
  Filter_Controller controller = Filter_Controller();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        // height: 35,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 10),
        child: FilterChip(
          onSelected: (value) {
            if (controller.choice.value) {
              Genres.remove(id);
              controller.choice.value = false;
            } else {
              Genres.add(id);
              controller.choice.value = true;
            }
          },
          selected: false,
          side: BorderSide(
              color: (controller.choice.value)
                  ? Colors.transparent
                  : (getStorage.read('isDarkMode') == true)
                      ? ColorValues.detailBorder
                      : ColorValues.darkModeThird.withValues(alpha: 0.10),
              width: 1),
          backgroundColor: (controller.choice.value)
              ? ColorValues.blueColor
              : (getStorage.read('isDarkMode') == true)
                  ? ColorValues.detailContainer
                  : ColorValues.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(
            text.capitalizeFirst.toString(),
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: (controller.choice.value) ? ColorValues.whiteColor : ColorValues.grayText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class Filter_Buttons5 extends StatelessWidget {
  String text;
  String id;

  Filter_Buttons5({super.key, required this.text, required this.id});
  Filter_Controller controller = Filter_Controller();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.center,
        child: FilterChip(
          onSelected: (value) {
            if (controller.choice.value) {
              year.remove(text);
              controller.choice.value = false;
            } else {
              year.add(text);
              controller.choice.value = true;
            }
          },
          selected: false,
          side: BorderSide(
              color: (controller.choice.value)
                  ? Colors.transparent
                  : (getStorage.read('isDarkMode') == true)
                      ? ColorValues.detailBorder
                      : ColorValues.darkModeThird.withValues(alpha: 0.10),
              width: 1),
          backgroundColor: (controller.choice.value)
              ? ColorValues.blueColor
              : (getStorage.read('isDarkMode') == true)
                  ? ColorValues.detailContainer
                  : ColorValues.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(
            text.capitalizeFirst.toString(),
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: (controller.choice.value) ? ColorValues.whiteColor : ColorValues.grayText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
