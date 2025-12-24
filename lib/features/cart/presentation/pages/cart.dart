import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_event.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_state.dart';
import 'package:mediecom/features/cart/presentation/pages/check_out_page.dart';
import 'package:mediecom/features/explore/presentation/widgets/gradient_appBar.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_state.dart';
import 'package:mediecom/injection_container.dart';

import '../../../explore/domain/entities/product_entity.dart';

class Cart extends StatelessWidget {
  static const path = '/cart';
  const Cart({super.key});

  static const Color _primaryLight = Color(0xFFF0F2F5);
  static const Color _cardBackground = Color(0xFFFFFFFF);
  static const Color _textColor = Color(0xFF212121);
  static const Color _subtextColor = Color(0xFF757575);
  static const Color _redAccent = Color(0xFFE53935);

  final double deliveryFee = 3.50;

  @override
  Widget build(BuildContext context) {
    final cacheHelper = sl<CacheHelper>();
    final user = cacheHelper.getUser();

    return Scaffold(
      appBar: GradientAppBar(name: 'Cart', address: '', isUserName: false),
      backgroundColor: _primaryLight,
      body: BlocListener<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state is OrderInsertSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: Colours.success,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
            context.read<CartBloc>().add(ClearCart());
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final items = cartState.items;
            final subtotal = cartState.subtotal;
            final totalAmount = subtotal + deliveryFee;
            final quanntity = cartState.quantities;
            final itemsMap = cartState.itemsMap;

            final cartPayload = prepareCartPayload(
              quanntity,
              totalAmount,
              user?.m2Id,
              itemsMap,
            );

            return Column(
              children: [
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/img_empty_cart.png",
                                height: 150,
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Your cart is empty',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _textColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: items.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final quantity =
                                cartState.quantities[item.M1_CODE] ?? 0;

                            return _buildCartItem(context, item, quantity)
                                .animate(
                                  delay: Duration(milliseconds: 120 * index),
                                )
                                .fadeIn(
                                  duration: const Duration(milliseconds: 300),
                                )
                                .slideX(
                                  begin: 0.3,
                                  duration: const Duration(milliseconds: 300),
                                );
                          },
                        ),
                ),
                if (items.isNotEmpty)
                  _buildCheckoutButton(
                    context,
                    subtotal,
                    totalAmount,
                    cartPayload,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    ProductEntity item,
    int quantity,
  ) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: _cardBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image.isNotEmpty ? resolveUrl(item.image[0]) : "",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey,
                    child: const Icon(
                      Iconsax.image,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.M1_NAME ?? 'Unknown Product',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.M1_CST ?? 'Unknown type',
                      style: const TextStyle(
                        fontSize: 13,
                        color: _subtextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (item.M1_DT4?.isNotEmpty ?? false)
                      Text(
                        'Expires: ${item.M1_DT4}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _subtextColor,
                        ),
                      ),
                    const SizedBox(height: 4),

                    if (item.M1_LST?.isNotEmpty ?? false)
                      Text(
                        'Batch: ${item.M1_LST}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _subtextColor,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs ${item.M1_AMT2}/-',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colours.success,
                          ),
                        ),
                        _buildQuantityControl(
                          context,
                          item.M1_CODE ?? '',
                          quantity,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Iconsax.trash, color: _redAccent),
            onPressed: () {
              context.read<CartBloc>().add(
                RemoveFromCart(productCode: item.M1_CODE ?? ''),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControl(
    BuildContext context,
    String productCode,
    int quantity,
  ) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Colours.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              context.read<CartBloc>().add(
                UpdateQuantity(
                  productCode: productCode,
                  quantity: quantity - 1,
                ),
              );
            },
            child: const SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: Icon(Iconsax.minus, color: Colors.white, size: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "$quantity",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context.read<CartBloc>().add(
                UpdateQuantity(
                  productCode: productCode,
                  quantity: quantity + 1,
                ),
              );
            },
            child: const SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: Icon(Iconsax.add, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(
    BuildContext context,
    double subtotal,
    double totalAmount,
    Map<String, dynamic> cartPayload,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _subtextColor,
                ),
              ),
              Text(
                '${subtotal.toStringAsFixed(2)}/-',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colours.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Fee',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _subtextColor,
                ),
              ),
              Text(
                '${deliveryFee.toStringAsFixed(2)}/-',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colours.success,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: _primaryLight),
          Column(
            children: [
              Text(
                'Total Amt: ${totalAmount.toStringAsFixed(2)}/-',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => context.push(
                  PaymentMethodPage.path,
                  extra: {
                    'subtotal': subtotal,
                    'deliveryFee': deliveryFee,
                    'totalAmount': totalAmount,
                    'cartPayload': cartPayload,
                  },
                ),
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colours.accentCoral,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Center(
                    child: Text(
                      "Check Out",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Map<String, dynamic> prepareCartPayload(
  Map<String, int> quantities,
  double getPrice,
  String? userId,
  Map<String, ProductEntity> itemsMap,
) {
  // Extract product codes and quantities as lists
  final productCodes = quantities.keys.toList();
  final qtys = quantities.values.toList();

  // Create comma-separated strings
  final f4Party = productCodes.join(',');
  final f4Qty = qtys.join(',');

  // Prepare detailed item information
  final List<Map<String, dynamic>> items = [];
  for (var code in productCodes) {
    final product = itemsMap[code];
    if (product != null) {
      items.add({
        'productCode': code,
        'productName': product.M1_NAME,
        'formula': product.M1_CST,
        'batch': product.M1_LST,
        'expiry': product.M1_DT4,
        'quantity': quantities[code],
        'rate': product.M1_AMT2,
        'amount': (double.tryParse(product.M1_AMT2 ?? '0') ?? 0) * (quantities[code] ?? 0),
      });
    }
  }

  // Create final payload map
  final payload = {
    "user_id": userId,
    "F4_PARTY": f4Party,
    "F4_QTY": f4Qty,
    "grand_total": getPrice,
    "items": items, // Include detailed item information
  };

  return payload;
}
