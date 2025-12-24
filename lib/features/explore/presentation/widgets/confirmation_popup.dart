import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediecom/features/explore/presentation/pages/home_screen.dart';

class PrescriptionUploadedPopup extends StatefulWidget {
  const PrescriptionUploadedPopup({super.key});

  @override
  State<PrescriptionUploadedPopup> createState() =>
      _PrescriptionUploadedPopupState();
}

class _PrescriptionUploadedPopupState extends State<PrescriptionUploadedPopup> {
  @override
  void initState() {
    super.initState();

    // Auto dismiss after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) context.go(HomeScreen.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(HomeScreen.path), // Tap to dismiss
      child: Scaffold(
        backgroundColor: Colors.black54, // Dimmed background (overlay)
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
                const SizedBox(height: 16),
                Text(
                  "Uploaded Successfully!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Your prescription has been uploaded.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
