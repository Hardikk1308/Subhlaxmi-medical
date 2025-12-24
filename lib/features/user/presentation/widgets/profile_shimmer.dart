import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          // Profile Image Shimmer
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),

          // Name + Mobile Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name shimmer
              Container(width: 150, height: 16, color: Colors.white),
              const SizedBox(height: 10),

              // Mobile shimmer
              Container(width: 100, height: 14, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
