import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../style/app_colors.dart';

class PrefixInputTextPassword extends StatefulWidget {
  const PrefixInputTextPassword({
    super.key,
    required this.hint,
    this.preFixIcon,
    required this.keyboardType,
    this.maxLength,
    this.controller,
    this.validator,
    this.obscureText = false,
  });

  final String hint;
  final Icon? preFixIcon;
  final TextInputType keyboardType;
  final int? maxLength;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  _PrefixInputTextPasswordState createState() =>
      _PrefixInputTextPasswordState();
}

class _PrefixInputTextPasswordState extends State<PrefixInputTextPassword> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.h),
      child: TextFormField(
        obscureText: _obscureText,
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        style: const TextStyle(color: Colours.dark, fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colours.dark, fontSize: 14),
          prefixIcon: widget.preFixIcon,
          fillColor: Colours.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide.none, // No border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide.none, // No border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide.none, // No border
          ),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: _togglePasswordView,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colours.dark,
                      size: 22.h,
                    ),
                  ),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 10.w,
          ),
        ),
      ),
    );
  }
}
