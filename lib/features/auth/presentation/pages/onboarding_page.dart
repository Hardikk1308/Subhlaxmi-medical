import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/common/widgets/safe_lottie_loader.dart';
import 'package:mediecom/core/constants/media_constants.dart';
import 'package:mediecom/core/extentions/color_extensions.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/features/auth/presentation/auth_injection.dart';
import 'package:mediecom/features/auth/presentation/pages/phone_number.dart';

import '../../../../injection_container.dart';

class OnboardingPage extends StatelessWidget {
  static const path = '/onboarding-page';
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cacheHelper = sl<CacheHelper>();
    cacheHelper.setIsFirstTime(false);

    return Scaffold(
      backgroundColor: Colours.primaryColor,
      body: Column(
        children: [
          // 🩵 Top Section: Animated medicine boxes
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gradient background
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      // colors: [Color(0xFF5AB7FF), Color(0xFF007BFF)],
                      colors: [
                        Color.fromARGB(255, 93, 243, 248),
                        Colours.primaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Floating Lottie Animation (or custom pills)
                Positioned(
                  bottom: 0,
                  child: SafeLottie(
                    asset: AppMedia.lottieDoctorAura,
                    height: 500.h,
                    width: 500.w,
                  ),
                ).animate().fadeIn(),
              ],
            ),
          ),

          // 🤍 Bottom Section: Welcome + Button
          Expanded(
            flex: 2,
            child: Container(
              clipBehavior: Clip.antiAlias,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to Subhlaxmi Medicines",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      // fontFamily: "Roboto",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Order medicines online with ease and reliability.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colours.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        context.go(PhoneNumberPage.path);
                      },
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
