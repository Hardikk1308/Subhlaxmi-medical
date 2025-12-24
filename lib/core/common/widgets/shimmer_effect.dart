// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../styles/app_colors.dart';
//
// class ShimmerEffect extends StatelessWidget {
//   const ShimmerEffect({
//     super.key,
//      this.width,
//      this.height,
//     this.radius = 0,
//     this.color,
//   });
//
//   final double? width, height, radius;
//   final Color? color;
//
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       primaryColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: color ?? Colours.white,
//           borderRadius: BorderRadius.circular(radius != null ? radius! : 0),
//         ),
//       ),
//     );
//   }
// }
//
//
