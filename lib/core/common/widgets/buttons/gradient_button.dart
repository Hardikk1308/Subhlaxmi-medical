import 'package:flutter/material.dart';

import '../../../style/app_colors.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.color1 = Colours.primaryColor,
    this.color2 = Colours.secondaryColor,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  final String buttonText;
  final VoidCallback onPressed;
  final Color color1;
  final Color color2;
  final Alignment begin;
  final Alignment end;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: begin,
          end: end,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors
            .transparent, // Make the material transparent to show the gradient
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(
            30,
          ), // Match the container's borderRadius
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            child: Center(
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
