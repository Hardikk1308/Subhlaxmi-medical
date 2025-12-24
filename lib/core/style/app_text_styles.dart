import 'package:flutter/material.dart';

class AppTextStyles {
  static const String montserrat = 'Montserrat';

  // Dynamic Montserrat TextStyle
  static TextStyle montserratStyle({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: montserrat,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      fontStyle: fontStyle,
      fontVariations: [FontVariation('wght', weight.index * 100)],
    );
  }

  // Predefined shortcuts (optional)
  static TextStyle w300(double size) =>
      montserratStyle(size: size, weight: FontWeight.w300);

  static TextStyle w400(double size) =>
      montserratStyle(size: size, weight: FontWeight.w400);

  static TextStyle w500(double size) =>
      montserratStyle(size: size, weight: FontWeight.w500);

  static TextStyle w600(double size) =>
      montserratStyle(size: size, weight: FontWeight.w600);

  static TextStyle w700(double size) =>
      montserratStyle(size: size, weight: FontWeight.w700);

  static TextStyle w800(double size) =>
      montserratStyle(size: size, weight: FontWeight.w800);

  static TextStyle w900(double size) =>
      montserratStyle(size: size, weight: FontWeight.w900);
}
