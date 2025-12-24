import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediecom/core/constants/media_constants.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/style/app_text_styles.dart';

class FeatureComingSoonWidget extends StatelessWidget {
  const FeatureComingSoonWidget({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppMedia.imgComingSoon, // Your new SVG asset
              height: 200.r,
            ),
            SizedBox(height: 30.h),
            Text('Coming Soon!', style: AppTextStyles.w800(24)),
            SizedBox(height: 12.h),
            Text(
              'We are working hard to bring this feature to you. Please check back later.',
              textAlign: TextAlign.center,
              style: AppTextStyles.w300(12),
            ),
            if (showBackButton) ...[
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colours.white,
                  // foregroundColor: Colours.whiteColour,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text('Go Back', style: AppTextStyles.w600(16)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
