import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediecom/core/extentions/color_extensions.dart';

import '../../style/app_colors.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop();
      },
      child: Container(
        height: 26.h,
        width: 26.w,
        margin: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colours.neutralGray.o20,
          // borderRadius: BorderRadius.circular(50.r),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18.r,
          color: Colours.dark,
        ),
      ),
    );
  }
}
