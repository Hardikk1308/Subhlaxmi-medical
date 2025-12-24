import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopBannerShimmer extends StatelessWidget {
  const TopBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150, // same height as your carousel
          child: PageView.builder(
            itemCount: 3, // number of shimmer banners
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: _BannerSkeleton(),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // // Dots shimmer
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: List.generate(
        //     3,
        //     (index) => Container(
        //       width: index == 0 ? 20 : 8,
        //       height: 8,
        //       margin: const EdgeInsets.symmetric(horizontal: 4),
        //       decoration: BoxDecoration(
        //         color: Colors.grey[300],
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class _BannerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 6,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
      ),
    );
  }
}
