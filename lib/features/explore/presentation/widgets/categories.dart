import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/constants/api_constants.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/features/master/domain/entities/category_entity.dart';
import 'package:mediecom/features/master/presentation/pages/subcategory_page.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryEntity> cate;

  CategoryList({super.key, required this.cate});

  Color getRandomColor() {
    final random = Random();
    const colors = [
      Color(0xFFFFF3CD),
      Color(0xFFFFE4E1),
      Color(0xFFD7F9F7),
      Color(0xFFDCE7FF),
      Color(0xFFFFF2F2),
      Color(0xFFE9F8E5),
      Color(0xFFE3F2FD),
      Color(0xFFFCE4EC),
    ];
    return colors[random.nextInt(colors.length)];
  }

  /// icons IN SAME ORDER as your backend list
  final List<IconData> categoryIcons = [
    Iconsax.health5, // Diabetes essential
    Iconsax.magicpen5, // New age store
    Iconsax.brush_4, // Personal care
    Iconsax.activity, // Vitamins & supplements
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Adjust based on how tall you want each item
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: cate.length,
        itemBuilder: (context, index) {
          final category = cate[index];

          return TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 600 + (index * 80)),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => context.push(SubcategoryPage.path),
                child: Container(
                  width: 95,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colours.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 66,
                        height: 63,
                        decoration: BoxDecoration(
                          color: getRandomColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // child: Icon(
                        //   categoryIcons[index % categoryIcons.length],
                        //   color: Colors.black,
                        //   size: 28,
                        // ),
                        child: Image.network(
                          height: 20,
                          '${ApiConstants.categoryBase}${category.m1dc1}',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.m1Name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
