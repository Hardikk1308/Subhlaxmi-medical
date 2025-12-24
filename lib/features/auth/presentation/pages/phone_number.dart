import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/features/auth/presentation/bloc/send_otp/send_otp_bloc.dart';
import 'package:mediecom/features/auth/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'otp_verification_page.dart';

class PhoneNumberPage extends StatefulWidget {
  static const path = '/phone-number';
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneValid = false;

  // Indian phone number regex (10 digits, starting with 6-9)
  final RegExp _phoneRegex = RegExp(r'^[6-9]\d{9}$');

  void _validatePhone(String value) {
    setState(() {
      _isPhoneValid = _phoneRegex.hasMatch(value);
    });
  }

  void _sendOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text.trim();

      // Trigger Bloc event
      context.read<SignInBloc>().add(MobileSignInEvent(mobile: phone));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BlocListener<SignInBloc, SignInState>(
            listener: (context, state) {
              if (state is SignInSuccess) {
                context.push(
                  OtpVerificationPage.path,
                  extra: _phoneController.text.trim(),
                );
              } else if (state is SignInError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Something went wrong"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Logo Section
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
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'Enter your phone number to continue',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Phone Input Field
                    _buildPhoneInputField(),

                    const SizedBox(height: 12),

                    // Helper Text
                    if (_phoneController.text.isNotEmpty && !_isPhoneValid)
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.red[400],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Please enter a valid 10-digit mobile number',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[400],
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 12),

                    // Send OTP Button
                    _buildSendOtpButton(),

                    const SizedBox(height: 40),

                    // Security Info
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Your information is secure with us',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isPhoneValid
              ? Colours.primaryColor.withOpacity(0.5)
              : Colors.grey[300]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isPhoneValid
                ? Colours.primaryColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        onChanged: _validatePhone,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          hintText: 'Enter 10-digit mobile number',
          hintStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey[400],
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colours.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '+91',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colours.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(height: 24, width: 1.5, color: Colors.grey[300]),
              ],
            ),
          ),
          suffixIcon: _phoneController.text.isNotEmpty
              ? Icon(
                  _isPhoneValid ? Icons.check_circle : Icons.cancel,
                  color: _isPhoneValid ? Colors.green : Colors.red[300],
                  size: 22,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 16.0,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }
          if (!_phoneRegex.hasMatch(value)) {
            return 'Please enter a valid 10-digit mobile number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSendOtpButton() {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        final isLoading = state is SignInLoading;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isPhoneValid
                  ? Colours.primaryColor
                  : Colors.grey[300],
              disabledBackgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: _isPhoneValid ? 4 : 0,
              shadowColor: Colours.primaryColor.withOpacity(0.4),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Send OTP',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
