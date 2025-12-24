import 'package:flutter/material.dart';
import 'package:mediecom/core/extentions/context_extensions.dart';

import '../../../style/app_colors.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.height,
    required this.onPressed,
    required this.title,
    this.radius = 10,
    this.fontSize = 20.0, // Default font size
  });

  final double height;
  final double radius;
  final void Function() onPressed;
  final String title;
  final double fontSize; // New fontSize parameter

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      minWidth: context.width,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      color: Colours.primaryColor,
      child: Text(
        title,
        style: TextStyle(
          // Remove const here
          color: Colours.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          fontFamily: '',
        ),
      ),
    );
  }
}
