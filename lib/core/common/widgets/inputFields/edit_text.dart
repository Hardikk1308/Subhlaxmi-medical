import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HoursInputField extends StatelessWidget {
  final int? maxLength;
  final Color? backgroundColor;
  final Color? textColor;
  final String hint;
  final bool? readOnly;
  final TextInputType inputType;

  const HoursInputField({super.key, 
    this.maxLength,
    this.backgroundColor,
    this.textColor,
    this.readOnly,
    required this.inputType,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly ?? false,
      keyboardType: inputType,
      inputFormatters: (maxLength == 50 && inputType == TextInputType.text)
          ? [] // Allow full text input if maxLength is 50 and inputType is text
          : [
        FilteringTextInputFormatter.digitsOnly,
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 18,
        color: textColor,
      ),
    );
  }
}
