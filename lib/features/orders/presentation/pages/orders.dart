import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/extentions/color_extensions.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/features/auth/presentation/auth_injection.dart';
import 'package:mediecom/features/explore/presentation/widgets/gradient_appBar.dart';
import 'package:mediecom/features/orders/domain/entities/order_entity.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_event.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_state.dart';
import 'package:mediecom/features/orders/presentation/pages/orders_detail.dart';

import '../../../../injection_container.dart';

class Orders extends StatefulWidget {
  static const path = '/order';
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with WidgetsBindingObserver {
  final cacheHelper = sl<CacheHelper>();
  List<OrderEntity>? _cachedOrders;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchOrders();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchOrders();
    }
  }

  void _fetchOrders() {
    final String userId = cacheHelper.getUserId() ?? "";
    context.read<OrdersBloc>().add(FetchOrderListEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(name: 'Orders', address: '', isUserName: false),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          // Always cache successful orders
          if (state is OrderListSuccess) {
            _cachedOrders = state.orders;
          }

          // Show cached orders if available, otherwise show appropriate state
          if (_cachedOrders != null) {
            return _buildOrdersList(_cachedOrders!);
          }

          return switch (state) {
            OrdersInitial() => _buildLoadingOrEmpty(),
            OrdersLoading() => const Center(child: CircularProgressIndicator()),
            OrdersFailure(message: final message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchOrders,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            OrderListSuccess(orders: final orders) => _buildOrdersList(orders),
            _ => const SizedBox(),
          };
        },
      ),
    );
    // Track Order Section
    // Text(
    //   'Track Order',
    //   style: TextStyle(
    //     fontWeight: FontWeight.bold,
    //     fontSize: 20,
    //     color: Colors.grey[800],
    //   ),
    // ),
    // const SizedBox(height: 16),
    // _buildTrackingTimeline(),
    //       ],
    //     ),
    //   ),
    // );
  }

  String formatOrderDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildLoadingOrEmpty() {
    // Fetch orders on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchOrders();
      }
    });
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildOrdersList(List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          "No orders yet.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: orders.asMap().entries.map((entry) {
          final index = entry.key;
          final order = entry.value;

          return _buildOrderId(order)
              .animate(
                delay: Duration(milliseconds: 130 * index),
              )
              .fadeIn(duration: 300.ms)
              .slideX(
                begin: 0.3,
                duration: 350.ms,
              );
        }).toList(),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String getOrderStatus(String status) {
    return switch (status) {
      '1' => 'Pending',
      '2' => 'Confirmed',
      '3' => 'Dispatched',
      '4' => 'Delivered',
      '5' => 'Cancelled',
      _ => 'Processing',
    };
  }

  String getPaidStatus(String status) {
    return switch (status) {
      '0' => 'Unpaid',
      '1' => 'Paid',
      '2' => 'Advance Paid',

      _ => 'Processing',
    };
  }

  Color getPaidStatusColor(String status) {
    return switch (status) {
      '0' => Colors.red, // unpaid
      '1' => Colors.green, // paid
      '2' => Colors.blueAccent, // advance
      _ => Colors.grey,
    };
  }

  Color getStatusColor(String status) {
    return switch (status) {
      '1' => Colors.orangeAccent, // pending
      '2' => Colors.blue, // confirmed
      '3' => Colors.deepPurple, // dispatched / in-transit
      '4' => Colors.green, // delivered
      '5' => Colors.red, // cancelled
      _ => Colors.grey, // default
    };
  }

  String getPaymentMethod(String status) {
    return switch (status) {
      '0' => 'Online',
      '1' => 'Cash',
      '2' => 'Advance Paid',

      _ => 'Processing',
    };
  }

  Color getPaymentMethodColor(String pm) {
    return switch (pm) {
      '2' => Colors.red, // unpaid
      '1' => Colors.green, // paid
      '0' => Colors.blueAccent, // advance
      _ => Colors.grey,
    };
  }

  Widget _buildOrderId(OrderEntity order) {
    return GestureDetector(
      onTap: () => context.push(OrderTrackingPage.path, extra: order),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38.o10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order#: ${order.f4No ?? ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colours.dark,
                        ),
                      ),

                      if (order.f4Pm != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getPaymentMethodColor(order.f4Pm ?? '').o10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            getPaymentMethod(order.f4Pm ?? ''),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: getPaymentMethodColor(order.f4Pm ?? ''),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Placed on ${formatOrderDate(order.f4Userdt ?? '')}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(order.f4Bt ?? '').o10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          getOrderStatus(order.f4Bt ?? ''),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: getStatusColor(order.f4Bt ?? ''),
                          ),
                        ),
                      ),

                      SizedBox(width: 10.w),

                      if (order.f4Ps != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getPaidStatusColor(order.f4Ps ?? '').o10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            getPaidStatus(order.f4Ps ?? ''),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: getPaidStatusColor(order.f4Ps ?? ''),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Total Amount Section
                  SizedBox(height: 12.h),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.teal.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '₹${order.f4Amt2 ?? '0.00'}', // Replace with your actual field
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            bottom: 0,
            right: 8,
            child: Icon(
              size: 22,
              Icons.arrow_forward_ios,
              color: Colours.neutralGray,
            ),
          ),
        ],
      ),
    );
  }
}
