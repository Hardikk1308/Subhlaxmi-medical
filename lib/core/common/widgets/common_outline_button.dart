import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediecom/core/extentions/context_extensions.dart';

class CommonOutLineButton extends StatelessWidget {
  const CommonOutLineButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.textStyle,
    required this.backgroundColor,
    required this.borderColor,
    required this.buttonPaddingHeight,
    required this.buttonPaddingWidth,
    this.borderRadius = 100,
  });

  final String buttonText;
  final Function()? onTap;
  final double buttonPaddingHeight, buttonPaddingWidth;
  final TextStyle textStyle;
  final Color backgroundColor, borderColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            side: BorderSide(
              color: borderColor,
              // Change this to your desired border color
              width: 1.w, // Adjust the width of the border
            ),
          ),
          backgroundColor: backgroundColor,
          padding: EdgeInsets.fromLTRB(
            buttonPaddingWidth,
            buttonPaddingHeight,
            buttonPaddingWidth,
            buttonPaddingHeight,
          ),
        ),
        onPressed: onTap,
        child: Text(buttonText, style: textStyle /*textStyle*/),
      ),
    );
  }
}
