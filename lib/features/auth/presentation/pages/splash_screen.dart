import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/constants/media_constants.dart';
import 'package:mediecom/core/extentions/context_extensions.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/auth/presentation/auth_injection.dart';
import 'package:mediecom/features/auth/presentation/pages/onboarding_page.dart';
import 'package:mediecom/features/auth/presentation/pages/phone_number.dart';
import 'package:mediecom/features/explore/presentation/pages/home_screen.dart';
import 'package:mediecom/features/user/presentation/pages/location_fetcher.dart';
import 'package:mediecom/features/user/presentation/pages/update_profile.dart';

import '../../../../injection_container.dart';
// import 'package:skillslinks/core/constants/media_constants.dart';
// import 'package:skillslinks/core/extentions/context_extensions.dart';
// import 'package:skillslinks/features/auth/presentation/screens/welcome_screen.dart';
// import 'package:skillslinks/vendor_features/dashboard/presentation/screens/home_dashboard.dart';

// import '../../../../core/common/app/cache_helper.dart';
// import '../../../../core/services/injection/injectiontion_container.dart';
// import '../../../user/presentation/screens/create_profile_screen.dart';
// import '../../../user/presentation/screens/fetch_location_screen.dart';
// import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final cacheHelper = sl<CacheHelper>();

    // 1. First time?
    if (cacheHelper.isFirstTime()) {
      context.go(OnboardingPage.path);
      return;
    }

    // 2. Logged in?
    if (!cacheHelper.isLoggedIn()) {
      context.go(PhoneNumberPage.path);
      return;
    }

    // 3. Profile complete?
    final user = cacheHelper.getUser();
    if (user == null || user.m2Chk1 == null || user.m2Chk1!.isEmpty) {
      context.go(UpdateProfileScreen.path);
      return;
    }

    // 4. CHECK IF LOCATION ALREADY EXISTS
    final hasLat = cacheHelper.getLatitude();
    final hasLng = cacheHelper.getLongitude();

    if (hasLat == null || hasLng == null) {
      /// 🚀 Send to Animated Location Fetcher
      context.go(LocationPage.path);

      return;
    }

    // 5. If everything is done → go home
    context.go(HomeScreen.path);
  }

  @override
  Widget build(BuildContext context) {
    // Using a Scaffold is a more standard and robust approach
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppMedia.imgSplash,
            height: context.height,
            width: context.width,
            // fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 100.h,
            left: 0,
            right: 0,
            child: const Center(
              child: CircularProgressIndicator(color: Colours.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
