import 'dart:developer';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mediecom/features/auth/presentation/bloc/send_otp/send_otp_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/common/widgets/full_screen_loader.dart';
import 'package:mediecom/core/constants/api_constants.dart';
import 'package:mediecom/core/extentions/text_style_extentions.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/style/app_text_styles.dart';
import 'package:mediecom/features/auth/presentation/bloc/verify_otp/verify_otp_bloc.dart';
import 'package:mediecom/features/explore/presentation/pages/home_screen.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/presentation/pages/location_fetcher.dart';
import 'package:mediecom/features/user/presentation/pages/update_profile.dart';
import 'package:mediecom/features/account_review/presentation/pages/account_review_page.dart';

import '../../../../injection_container.dart';

class OtpVerificationPage extends StatefulWidget {
  static const path = '/otp-verification';
  final String phoneNumber;
  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isOtpComplete = false;

  // Timer for resend OTP
  int _resendTimer = 30;
  Timer? _timer;
  bool _canResend = false;

  var _otpUserId;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    context.read<SendOtpBloc>().add(
      MobileSendOtpEvent(userId: widget.phoneNumber),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 30;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _verifyOtp() {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colours.accentCoral,
          content: const Text('Please enter the complete 6-digit OTP'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Check if we have the OTP user ID
    if (_otpUserId == null || _otpUserId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colours.accentCoral,
          content: const Text('Please wait for OTP to be sent'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Trigger Bloc event with the ID from SendOtp success
    context.read<VerifyOtpBloc>().add(
      MobileVerifyOtpEvent(
        otp: _otpController.text.trim(),
        userId: _otpUserId!, // Use the ID from SendOtp response
      ),
    );
  }

  void _resendOtp() {
    if (_canResend) {
      // Trigger SendOtp again
      context.read<SendOtpBloc>().add(
        MobileSendOtpEvent(userId: widget.phoneNumber),
      );

      _startResendTimer();
      _otpController.clear();
      setState(() {
        _isOtpComplete = false;
        _otpUserId = null; // Reset the ID
      });
    }
  }

  Future<void> _fetchAndCheckAccountStatus(
    BuildContext context,
    String userId,
  ) async {
    try {
      // First, check user details to see if M2_BT is active
      log('🔍 Checking user details for M2_BT status...');
      final userDetailsResponse = await http.post(
        Uri.parse(ApiConstants.userDetails),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_id': userId},
      );

      log('🔍 User Details - Status Code: ${userDetailsResponse.statusCode}');
      log('🔍 User Details - Response Body: ${userDetailsResponse.body}');

      String m2Bt = '';
      if (userDetailsResponse.statusCode == 200) {
        try {
          final Map<String, dynamic> userDetailsBody = json.decode(
            userDetailsResponse.body,
          );
          if (userDetailsBody['response'] == 'success' &&
              userDetailsBody['data'] != null &&
              (userDetailsBody['data'] as List).isNotEmpty) {
            final userData = userDetailsBody['data'][0];
            m2Bt = userData['M2_BT']?.toString().toLowerCase() ?? '';
            log('🔍 User Details - M2_BT Status: "$m2Bt"');
          }
        } catch (e) {
          log('❌ User Details - JSON Parse Error: $e');
        }
      }

      // If M2_BT is active, skip account review and go directly to update profile
      if (m2Bt == 'active') {
        log(
          '✅ M2_BT is ACTIVE - Skipping Account Review, going to Update Profile',
        );
        if (mounted) {
          _proceedToNextPage(context);
        }
        return;
      }

      // Make API call to get application/company data
      final response = await http.post(
        Uri.parse(ApiConstants.application),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_id': userId},
      );

      log('🔍 Account Status Check - Status Code: ${response.statusCode}');
      log('🔍 Account Status Check - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          log('🔍 Account Status Check - Parsed Response: $responseBody');

          if (responseBody['response'] == 'success' &&
              responseBody['data'] != null &&
              (responseBody['data'] as List).isNotEmpty) {
            final companyData = responseBody['data'][0];
            log('🔍 Account Status Check - Company Data: $companyData');

            final status =
                companyData['CO_DES1']?.toString().toLowerCase() ?? '';
            log('🔍 Account Status Check - CO_DES1 Status: "$status"');

            // Check if account is under review
            if (status.contains('under review') ||
                status.contains('under reivew')) {
              log('✅ Account Status Check - Account is UNDER REVIEW');
              // Navigate to account review page
              final reviewData = AccountReviewData(
                logo:
                    companyData['CO_PER1']?.toString() ??
                    'assets/images/img_logo.png',
                companyName: companyData['CO_NAME']?.toString() ?? 'Company',
                description:
                    companyData['CO_DES1']?.toString() ??
                    'Your Account Is In An Under Review.',
                contactNumber:
                    companyData['CO_TEL1']?.toString() ??
                    companyData['CO_TEL']?.toString() ??
                    '7000980233',
                userId: userId,
              );
              log('✅ Account Status Check - Navigating to Account Review Page');
              if (mounted) {
                context.go(AccountReviewPage.path, extra: reviewData);
              }
              return;
            } else {
              log(
                'ℹ️ Account Status Check - Account is NOT under review (status: $status)',
              );
            }
          } else {
            log('⚠️ Account Status Check - No data in response');
            log('⚠️ Response: $responseBody');
          }
        } catch (e) {
          log('❌ Account Status Check - JSON Parse Error: $e');
        }
      } else {
        log(
          '❌ Account Status Check - Failed with status code: ${response.statusCode}',
        );
      }

      // If not under review or error, proceed with normal flow
      log('➡️ Account Status Check - Proceeding to next page');
      if (mounted) {
        _proceedToNextPage(context);
      }
    } catch (e) {
      log('❌ Error fetching account status: $e');
      // If error, proceed with normal flow
      if (mounted) {
        _proceedToNextPage(context);
      }
    }
  }

  void _proceedToNextPage(BuildContext context) {
    final cacheHelper = sl<CacheHelper>();
    final hasLat = cacheHelper.getLatitude();
    final hasLng = cacheHelper.getLongitude();
    final userId = cacheHelper.getUserId();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colours.success,
        content: const Text('OTP Verified! Logging in...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (userId == null || userId.isEmpty) {
      context.go(UpdateProfileScreen.path);
    } else if (hasLat == null || hasLng == null) {
      context.go(LocationPage.path);
    } else {
      context.go(HomeScreen.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pinput theme configuration
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colours.primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colours.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colours.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colours.primaryColor, width: 1.5),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A)),
          onPressed: () => context.pop(),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          // Listen to SendOtp Bloc
          BlocListener<SendOtpBloc, SendOtpState>(
            listener: (context, state) {
              if (state is SendOtpSuccess) {
                // Store the ID from SendOtp success
                setState(() {
                  _otpUserId = state.userId;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'OTP has been sent to your mobile number',
                    ),
                    backgroundColor: Colours.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              } else if (state is SendOtpError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colours.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
          ),
          // Listen to VerifyOtp Bloc
          BlocListener<VerifyOtpBloc, VerifyOtpState>(
            listener: (context, state) {
              if (state is VerifyOtpLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const FullScreenLoader(),
                );
              } else if (state is VerifyOtpError) {
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: AppTextStyles.w800(14).white,
                    ),
                    backgroundColor: Colours.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              } else if (state is VerifyOtpSuccess) {
                log(state.user.toString());
                final cacheHelper = sl<CacheHelper>();
                cacheHelper.setIsLoggedIn(true);
                cacheHelper.cacheUserId(state.user.m2Id ?? "");

                //LOAD LAT LNG
                final hasLat = cacheHelper.getLatitude();
                final hasLng = cacheHelper.getLongitude();

                final UserModel user = state.user;
                cacheHelper.cacheUser(user);
                Navigator.of(context, rootNavigator: true).pop();

                // Fetch company/application data to check account status
                _fetchAndCheckAccountStatus(context, state.user.m2Id ?? "");
              }
            },
          ),
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Logo with animation
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colours.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/img_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                const Text(
                  'Verify Your Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle with phone number
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'We\'ve sent a 6-digit OTP to\n'),
                      TextSpan(
                        text: '+91 ${widget.phoneNumber}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colours.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // OTP Input Field with Pinput
                Pinput(
                  controller: _otpController,
                  focusNode: _focusNode,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  cursor: Container(
                    width: 2,
                    height: 24,
                    color: Colours.primaryColor,
                  ),
                  onCompleted: (pin) {
                    setState(() {
                      _isOtpComplete = true;
                    });
                    // Auto-verify when OTP is complete
                    _verifyOtp();
                  },
                  onChanged: (value) {
                    setState(() {
                      _isOtpComplete = value.length == 6;
                    });
                  },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                const SizedBox(height: 24),

                // Resend OTP Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive OTP? ",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    if (!_canResend)
                      Text(
                        'Resend in ${_resendTimer}s',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
                        ),
                      )
                    else
                      InkWell(
                        onTap: _resendOtp,
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colours.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 40),

                // Verify Button
                _buildVerifyButton(),

                const SizedBox(height: 30),

                // Help Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Having trouble?',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => print('Get Help'),
                        child: const Text(
                          'Get Help',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colours.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isOtpComplete ? _verifyOtp : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isOtpComplete
              ? Colours.primaryColor
              : Colors.grey[300],
          disabledBackgroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: _isOtpComplete ? 4 : 0,
          shadowColor: Colours.primaryColor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Verify & Login',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
