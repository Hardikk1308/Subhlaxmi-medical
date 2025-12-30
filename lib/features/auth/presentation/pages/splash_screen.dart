import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/constants/api_constants.dart';
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
import 'package:mediecom/features/account_review/presentation/pages/account_review_page.dart';
import 'package:mediecom/features/account_review/presentation/bloc/account_review_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    log('📍 Splash Screen - Starting route decision logic');

    // 1. First time?
    if (cacheHelper.isFirstTime()) {
      log('📍 Splash Screen - First time user, going to Onboarding');
      context.go(OnboardingPage.path);
      return;
    }

    // 2. Logged in?
    if (!cacheHelper.isLoggedIn()) {
      log('📍 Splash Screen - Not logged in, going to Phone Number');
      context.go(PhoneNumberPage.path);
      return;
    }

    // 3. Get user data
    final user = cacheHelper.getUser();
    if (user == null) {
      log('📍 Splash Screen - No user data, going to Update Profile');
      context.go(UpdateProfileScreen.path);
      return;
    }

    log('📍 Splash Screen - User found: ${user.m2Id}');
    log('📍 Splash Screen - User m2Chk1: "${user.m2Chk1}"');

    // 4. CHECK ACCOUNT STATUS FIRST - If account is under review, show account review page
    // This check must happen BEFORE profile completion check
    final userId = user.m2Id ?? '';
    if (userId.isNotEmpty) {
      log('📍 Splash Screen - Checking account status for userId: $userId');
      final isUnderReview = await _checkAccountStatus(userId);
      if (isUnderReview) {
        log('📍 Splash Screen - Account is under review, navigation handled');
        return; // Navigation already handled in _checkAccountStatus
      }
      log('📍 Splash Screen - Account is not under review, continuing');
    } else {
      log('⚠️ Splash Screen - No userId found, cannot check account status');
    }

    // 5. Profile complete?
    if (user.m2Chk1 == null || user.m2Chk1!.isEmpty) {
      log('📍 Splash Screen - Profile not complete, going to Update Profile');
      context.go(UpdateProfileScreen.path);
      return;
    }

    log('📍 Splash Screen - Profile is complete');

    // 6. CHECK IF LOCATION ALREADY EXISTS
    final hasLat = cacheHelper.getLatitude();
    final hasLng = cacheHelper.getLongitude();

    if (hasLat == null || hasLng == null) {
      log('📍 Splash Screen - Location not set, going to Location Fetcher');
      /// 🚀 Send to Animated Location Fetcher
      context.go(LocationPage.path);
      return;
    }

    log('📍 Splash Screen - Location is set, going to Home');

    // 7. If everything is done → go home
    context.go(HomeScreen.path);
  }

  Future<bool> _checkAccountStatus(String userId) async {
    try {
      log('🔍 Splash Screen - Checking account status for userId: $userId');
      
      // First, check user details to get M2_BT status (primary indicator)
      log('🔍 Splash Screen - Checking user details for M2_BT status...');
      final userDetailsResponse = await http.post(
        Uri.parse(ApiConstants.userDetails),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'user_id': userId},
      ).timeout(const Duration(seconds: 10));

      log('🔍 Splash Screen - User Details Status Code: ${userDetailsResponse.statusCode}');
      log('🔍 Splash Screen - User Details Response: ${userDetailsResponse.body}');

      String m2Bt = '';
      if (userDetailsResponse.statusCode == 200) {
        try {
          final Map<String, dynamic> userDetailsBody = jsonDecode(userDetailsResponse.body);
          if (userDetailsBody['response'] == 'success' &&
              userDetailsBody['data'] != null &&
              (userDetailsBody['data'] as List).isNotEmpty) {
            final userData = userDetailsBody['data'][0];
            m2Bt = userData['M2_BT']?.toString().toLowerCase() ?? '';
            log('🔍 Splash Screen - M2_BT Status: "$m2Bt" (original: "${userData['M2_BT']}")');
          }
        } catch (e) {
          log('❌ Splash Screen - User Details JSON Parse Error: $e');
        }
      }

      // If M2_BT is active, account is approved - continue normal flow
      if (m2Bt == 'active') {
        log('✅ Splash Screen - M2_BT is ACTIVE - Account is approved');
        return false;
      }

      // If M2_BT is not active, get company data for display info
      log('🔍 Splash Screen - M2_BT is not active, fetching company data...');
      final response = await http.post(
        Uri.parse(ApiConstants.application),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'user_id': userId},
      ).timeout(const Duration(seconds: 10));

      log('🔍 Splash Screen - Application Status Code: ${response.statusCode}');

      String logo = 'assets/images/img_logo.png';
      String companyName = 'Company';
      String description = 'Your Account Is In An Under Review.';
      String contactNumber = '7000980233';

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          if (responseBody['response'] == 'success' &&
              responseBody['data'] != null &&
              (responseBody['data'] as List).isNotEmpty) {
            final companyData = responseBody['data'][0];
            logo = companyData['CO_PER1']?.toString() ?? logo;
            companyName = companyData['CO_NAME']?.toString() ?? companyName;
            description = companyData['CO_DES1']?.toString() ?? description;
            contactNumber = companyData['CO_TEL1']?.toString() ?? 
                           companyData['CO_TEL']?.toString() ?? 
                           contactNumber;
            log('🔍 Splash Screen - Company Data fetched successfully');
          }
        } catch (e) {
          log('❌ Splash Screen - Application JSON Parse Error: $e');
        }
      }

      log('✅ Splash Screen - Account is UNDER REVIEW (M2_BT is not active)');
      
      final reviewData = AccountReviewData(
        logo: logo,
        companyName: companyName,
        description: description,
        contactNumber: contactNumber,
        userId: userId,
      );
      
      if (mounted) {
        context.go(AccountReviewPage.path, extra: reviewData);
      }
      return true;
    } catch (e) {
      log('❌ Splash Screen - Error checking account status: $e');
      return false;
    }
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
