
import 'package:flutter/material.dart';

class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color color;
  final Color unfilledColor;
  final IconData fullStar;
  final IconData halfStar;
  final IconData emptyStar;
  final double spacing; // Optional spacing between stars

  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 24.0,
    this.color = Colors.amber,
    this.unfilledColor = Colors.grey,
    this.fullStar = Icons.star,
    this.halfStar = Icons.star_half,
    this.emptyStar = Icons.star_border,
    this.spacing = 0.0, // Default to no extra spacing
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (int i = 0; i < starCount; i++) {
      IconData iconData;
      Color iconColor;

      if (rating >= i + 1) {
        iconData = fullStar;
        iconColor = color;
      } else if (rating >= i + 0.5) {
        iconData = halfStar;
        iconColor = color;
      } else {
        iconData = emptyStar;
        iconColor = unfilledColor;
      }

      stars.add(Icon(
        iconData,
        size: size,
        color: iconColor,
      ));

      // Add spacing if it's not the last star and spacing is greater than 0
      if (spacing > 0 && i < starCount - 1) {
        stars.add(SizedBox(width: spacing));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min, // So the Row doesn't take full width
      children: stars,
    );
  }
}