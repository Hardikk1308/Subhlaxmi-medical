import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../style/app_colors.dart';

class PrefixInputText extends StatelessWidget {
  const PrefixInputText({
    super.key,
    required this.hint,
    this.preFixIcon,
    required this.keyboardType,
    this.maxLength,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.borderColor,
    this.suffixBackgroundColor = Colours.white,
    this.onSuffixPressed,
    this.suffixColor = Colours.white,
  });

  final String hint;
  final Icon? preFixIcon;
  final TextInputType keyboardType;
  final int? maxLength;
  final Icon? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Color? borderColor;
  final Color suffixBackgroundColor;
  final Color suffixColor;
  final void Function()? onSuffixPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0.r),
          color: Colours.white,
        ),
        child: TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: const TextStyle(color: Colours.dark, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colours.dark, fontSize: 14),
            prefixIcon: preFixIcon,
            fillColor: Colors.transparent,
            filled: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: GestureDetector(
                      onTap: onSuffixPressed,
                      child: CircleAvatar(
                        radius: 12.0.r,
                        backgroundColor: suffixBackgroundColor,
                        foregroundColor: Colours.primaryColor,
                        child: suffixIcon,
                      ),
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(
              vertical: 15.h,
              horizontal: 10.w,
            ),
          ),
        ),
      ),
    );
  }
}
