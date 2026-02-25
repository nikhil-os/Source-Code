import 'package:flutter/material.dart';

class ProfileModal {
  String iconImage;
  String tital;
  String? subTital;
  Widget widget;
  void Function() onTap;

  ProfileModal({
    required this.widget,
    required this.iconImage,
    this.subTital,
    required this.tital,
    required this.onTap,
  });
}
