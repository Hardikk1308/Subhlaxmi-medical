import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SafeLottie extends StatelessWidget {
  final String asset;
  final double? height;
  final double? width;
  final bool repeat;
  final bool animate;

  const SafeLottie({
    super.key,
    required this.asset,
    this.height,
    this.width,
    this.repeat = true,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      height: height,
      width: width,
      repeat: repeat,
      animate: animate,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // ✅ fallback UI if Lottie file missing or fails to load
        return SizedBox(
          height: height,
          width: width,
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.redAccent),
          ),
        );
      },
    );
  }
}
