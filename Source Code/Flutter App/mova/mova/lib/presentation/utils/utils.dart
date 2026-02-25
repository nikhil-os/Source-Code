import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppUtils {
  static void showLog(String text) => log(text);

  static double systemBottomPadding({required BuildContext context, int? padding}) => (math.max(
        0,
        (MediaQuery.of(context).viewPadding.bottom + (padding ?? 0)),
      ));
}

extension HeightExtension on num {
  SizedBox get height => SizedBox(height: toDouble());
}

extension WidthExtension on num {
  SizedBox get width => SizedBox(width: toDouble());
}
