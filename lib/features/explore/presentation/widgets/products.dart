import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/style/app_text_styles.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_event.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_state.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity data;
  final int index;

  const ProductCard({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    double originalPrice = double.tryParse(data.M1_AMT1 ?? '0') ?? 0;
    double discountedPrice = double.tryParse(data.M1_AMT2 ?? '0') ?? 0;

    int discountPercent = 0;
    if (originalPrice > 0 && discountedPrice > 0) {
      discountPercent =
          (((originalPrice - discountedPrice) / originalPrice) * 100).round();
    }

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final quantity = cartState.quantities[data.M1_CODE] ?? 0;

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE SECTION
                  Stack(
                    children: [
                      Hero(
                        tag: "product_card_${data.M1_CODE}_$index",
                        child: Container(
                          height: 140.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFF8F9FA),
                                Colors.grey[100]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: data.image.isNotEmpty
                                    ? resolveUrl(data.image[0])
                                    : "",
                                fit: BoxFit.contain,
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(
                                    Iconsax.box,
                                    size: 48.sp,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // DISCOUNT BADGE
                      if (discountPercent > 0)
                        Positioned(
                          top: 8,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFEF4444,
                                  ).withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              "$discountPercent% OFF",
                              style: AppTextStyles.w700(11).copyWith(
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // PRODUCT DETAILS
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            data.M1_NAME ?? "Medicine Name",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.w700(14).copyWith(
                              color: const Color(0xFF1A1A1A),
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Iconsax.box,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                data.M1_CST ?? 'No formula available',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        if (data.M1_DT4?.isNotEmpty ?? false)
                          Row(
                            children: [
                              Icon(
                                Iconsax.ticket_expired,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),

                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  data.M1_DT4 ?? 'Expirey date not available',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Iconsax.card_pos,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),

                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                data.M1_LNAME ?? 'No Batch available',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        const Spacer(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2.0,
                                  horizontal: 3,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0FDF4),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "₹${data.M1_AMT2 ?? '0'}",
                                    style: AppTextStyles.w700(
                                      12,
                                    ).copyWith(color: const Color(0xFF10B981)),
                                  ),
                                ),
                              ),
                              if (originalPrice > discountedPrice)
                                Text(
                                  "₹${data.M1_AMT1}",
                                  style: AppTextStyles.w500(10).copyWith(
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.grey[500],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // CART BUTTON / QUANTITY SYNCED
            Positioned(
              bottom: 8,
              right: 8,
              child: _buildCartButton(context, quantity),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCartButton(BuildContext context, int quantity) {
    if (quantity == 0) {
      return InkWell(
        onTap: () {
          context.read<CartBloc>().add(AddToCart(item: data));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colours.primaryColor,
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colours.white),
                  SizedBox(width: 8.w),
                  Text(
                    '${data.M1_NAME} Added to cart',
                    style: AppTextStyles.w600(
                      14,
                    ).copyWith(color: Colours.white),
                  ),
                ],
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          height: 30,
          width: 30,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colours.primaryColor,
          ),
          child: const Icon(Iconsax.add, color: Colours.white, size: 18),
        ),
      );
    } else {
      return Container(
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colours.primaryColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                context.read<CartBloc>().add(
                  UpdateQuantity(
                    productCode: data.M1_CODE ?? '',
                    quantity: quantity - 1,
                  ),
                );
              },
              child: const SizedBox(
                width: 25,
                height: 30,
                child: Center(
                  child: Icon(Iconsax.minus, color: Colours.white, size: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "$quantity",
                style: AppTextStyles.w700(14).copyWith(color: Colours.white),
              ),
            ),
            InkWell(
              onTap: () {
                context.read<CartBloc>().add(
                  UpdateQuantity(
                    productCode: data.M1_CODE ?? '',
                    quantity: quantity + 1,
                  ),
                );
              },
              child: const SizedBox(
                width: 25,
                height: 30,
                child: Center(
                  child: Icon(Iconsax.add, color: Colours.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
