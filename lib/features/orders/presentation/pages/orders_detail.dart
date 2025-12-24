import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/explore/presentation/widgets/gradient_appBar.dart';
import 'package:mediecom/features/orders/domain/entities/order_details_entity.dart';
import 'package:mediecom/features/orders/domain/entities/order_entity.dart';
import 'package:mediecom/features/orders/domain/entities/order_history_entity.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';

class OrderTrackingPage extends StatefulWidget {
  static const path = '/order-tracking';
  final OrderEntity order;
  const OrderTrackingPage({super.key, required this.order});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  bool _hasLoadedHistory = false;
  List<OrderHistoryEntity> _orderHistory = [];
  OrderDetailsEntity? _orderDetails;

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(
      FetchOrderDetailsEvent(orderId: widget.order.f4No ?? ''),
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

  String formatOrderDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateStr;
    }
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
      '0' => const Color(0xFFEF4444),
      '1' => const Color(0xFF10B981),
      '2' => const Color(0xFF3B82F6),
      _ => Colors.grey,
    };
  }

  Color getStatusColor(String status) {
    return switch (status) {
      '1' => const Color(0xFFF59E0B),
      '2' => const Color(0xFF3B82F6),
      '3' => const Color(0xFF8B5CF6),
      '4' => const Color(0xFF10B981),
      '5' => const Color(0xFFEF4444),
      _ => Colors.grey,
    };
  }

  int _getStatusStep(String? status) {
    return switch (status) {
      '1' => 0,
      '2' => 1,
      '3' => 2,
      '4' => 3,
      '5' => -1,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: GradientAppBar(
        name: "Track Order",
        address: "address",
        isUserName: false,
        leading: true,
      ),
      body: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state is OrderDetailsSuccess && !_hasLoadedHistory) {
            _orderDetails = state.orderDetails;
            _hasLoadedHistory = true;
            context.read<OrdersBloc>().add(
              FetchOrderHistoryEvent(orderId: widget.order.f4Lcode ?? ""),
            );
          }
          if (state is OrderHistorySuccess) {
            setState(() {
              _orderHistory = state.orderHistory;
            });
          }
          // Silently handle order history failure - show page without items
          if (state is OrdersFailure && _hasLoadedHistory) {
            // Order history failed, but we already have order details, so just continue
          }
        },
        builder: (context, state) {
          if (state is OrdersLoading && _orderDetails == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colours.primaryColor),
            );
          }

          if (state is OrdersFailure && _orderDetails == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.info_circle, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16.h),
                  Text(
                    'Failed to load order details',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrdersBloc>().add(
                        FetchOrderDetailsEvent(
                          orderId: widget.order.f4No ?? '',
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_orderDetails != null) {
            final orderDetails = _orderDetails!;
            final currentStep = _getStatusStep(orderDetails.bt);
            final isCancelled = orderDetails.bt == '5';

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildOrderSummaryCard(orderDetails),
                        SizedBox(height: 16.h),
                        _buildCustomerDetailsCard(orderDetails),
                        SizedBox(height: 16.h),
                        if (_orderHistory.isNotEmpty)
                          _buildOrderHistorySection(),
                        SizedBox(height: 16.h),
                        if (!isCancelled)
                          _buildTrackingTimeline(currentStep, orderDetails),
                        if (isCancelled) _buildCancelledMessage(),
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildSupportButton(context),
    );
  }

  Widget _buildOrderSummaryCard(OrderDetailsEntity orderDetails) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${orderDetails.orderId ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      formatOrderDate(orderDetails.orderDate ?? ''),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (orderDetails.paymentMethod != null &&
                  orderDetails.paymentMethod!.isNotEmpty &&
                  orderDetails.paymentMethod != '0')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colours.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    orderDetails.paymentMethod!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colours.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.grey[200], thickness: 1),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grand Total',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹${orderDetails.grandTotal ?? '0'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              if (orderDetails.amt2 != null &&
                  orderDetails.amt2 != '0' &&
                  orderDetails.amt2!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Paid Amount',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '₹${orderDetails.amt2}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.grey[200], thickness: 1),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatusBadge(
                  getOrderStatus(orderDetails.bt ?? ''),
                  getStatusColor(orderDetails.bt ?? ''),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatusBadge(
                  getPaidStatus(orderDetails.ps ?? ''),
                  getPaidStatusColor(orderDetails.ps ?? ''),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsCard(OrderDetailsEntity orderDetails) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 16.h),
          _buildCustomerInfoRow(
            icon: Iconsax.user,
            label: 'Customer Name',
            value: orderDetails.customerName ?? 'N/A',
          ),
          SizedBox(height: 12.h),
          _buildCustomerInfoRow(
            icon: Iconsax.call,
            label: 'Contact Number',
            value: orderDetails.customerContact ?? 'N/A',
            isClickable: false,
          ),
          SizedBox(height: 12.h),
          _buildCustomerInfoRow(
            icon: Iconsax.profile_2user,
            label: 'Address',
            value: orderDetails.Address ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isClickable = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isClickable ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colours.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: Colours.primaryColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
            if (isClickable)
              Icon(Iconsax.call_calling, size: 18, color: Colours.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSupportButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () => launchDialer("7000980233"),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colours.primaryBackgroundColour,
          side: const BorderSide(color: Colours.primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          "Contact Support",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colours.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline(
    int currentStep,
    OrderDetailsEntity orderDetails,
  ) {
    final steps = [
      _TrackingStep(
        icon: Iconsax.tick_circle5,
        title: 'Order Placed',
        subtitle: formatOrderDate(orderDetails.orderDate ?? ''),
        isCompleted: currentStep >= 0,
        isCurrent: currentStep == 0,
      ),
      _TrackingStep(
        icon: Iconsax.box_tick5,
        title: 'Order Confirmed',
        subtitle: 'Processing your order',
        isCompleted: currentStep >= 1,
        isCurrent: currentStep == 1,
      ),
      _TrackingStep(
        icon: Iconsax.truck_fast,
        title: 'Out for Delivery',
        subtitle: 'On the way to you',
        isCompleted: currentStep >= 2,
        isCurrent: currentStep == 2,
      ),
      _TrackingStep(
        icon: Iconsax.home_25,
        title: 'Delivered',
        subtitle: 'Order completed',
        isCompleted: currentStep >= 3,
        isCurrent: currentStep == 3,
      ),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 20.h),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;
            return _buildTimelineItem(step, isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(_TrackingStep step, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: step.isCompleted
                    ? Colours.primaryColor
                    : Colors.grey[200],
                shape: BoxShape.circle,
                boxShadow: step.isCurrent
                    ? [
                        BoxShadow(
                          color: Colours.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                step.icon,
                color: step.isCompleted ? Colors.white : Colors.grey[400],
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: step.isCompleted
                        ? [Colours.primaryColor, Colours.primaryColor]
                        : [Colors.grey[300]!, Colors.grey[200]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 6.h, bottom: isLast ? 0 : 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: step.isCurrent
                        ? FontWeight.bold
                        : FontWeight.w600,
                    color: step.isCompleted
                        ? const Color(0xFF1A1A1A)
                        : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  step.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelledMessage() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.close_circle5,
              size: 64,
              color: Color(0xFFEF4444),
            ),
          ),
          SizedBox(height: 20.h),
          const Text(
            'Order Cancelled',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'This order has been cancelled. If you have any questions, please contact our support team.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHistorySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colours.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_orderHistory.length} ${_orderHistory.length == 1 ? 'Item' : 'Items'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colours.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...List.generate(
            _orderHistory.length,
            (index) => _buildOrderHistoryItem(_orderHistory[index], index),
          ),
          if (_orderHistory.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Divider(color: Colors.grey[200], thickness: 1),
            SizedBox(height: 12.h),
            _buildOrderItemsSummary(),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItemsSummary() {
    double totalQuantity = 0;
    double totalAmount = 0;
    double totalDiscount = 0;

    for (var item in _orderHistory) {
      totalQuantity += double.tryParse(item.quantity ?? '0') ?? 0;
      totalAmount += double.tryParse(item.total ?? '0') ?? 0;
      totalDiscount += double.tryParse(item.discount ?? '0') ?? 0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Items',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            Text(
              '${_orderHistory.length}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Quantity',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            Text(
              '${totalQuantity.toStringAsFixed(0)} units',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Items Total',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            Text(
              '₹${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colours.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderHistoryItem(OrderHistoryEntity item, int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: index < _orderHistory.length - 1 ? 12.h : 0,
      ),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image or Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colours.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  image:
                      item.productImage != null && item.productImage!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(item.productImage!),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                            // Fallback handled by showing icon
                          },
                        )
                      : null,
                ),
                child: item.productImage == null || item.productImage!.isEmpty
                    ? const Icon(
                        Iconsax.box5,
                        color: Colours.primaryColor,
                        size: 28,
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName ?? 'Unknown Product',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.productCst != null && item.productCst!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'Formula: ${item.productCst!}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (item.productLst != null && item.productLst!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Text(
                          'Batch: ${item.productLst!}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${item.total ?? '0'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colours.primaryColor,
                    ),
                  ),
                  if (item.discount != null &&
                      item.discount != '0' &&
                      item.discount!.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.discount}% OFF',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildInfoChip(
                icon: Iconsax.box_1,
                label: 'Qty: ${item.quantity ?? '0'}',
              ),
              if (item.rate != null && item.rate!.isNotEmpty)
                _buildInfoChip(icon: Iconsax.tag, label: 'Rate: ₹${item.rate}'),
              if (item.amount != null && item.amount!.isNotEmpty)
                _buildInfoChip(
                  icon: Iconsax.receipt,
                  label: 'Amount: ₹${item.amount}',
                ),
              if (item.productIt != null && item.productIt!.isNotEmpty)
                _buildInfoChip(
                  icon: Iconsax.barcode,
                  label: 'HSN: ${item.productIt}',
                ),
            ],
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () => _showItemDetailsBottomSheet(item),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View Full Details',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colours.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 14,
                  color: Colours.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colours.primaryColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colours.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showItemDetailsBottomSheet(OrderHistoryEntity item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  const Text(
                    'Item Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Iconsax.close_circle),
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[200], thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Product Name', item.productName ?? 'N/A'),
                    _buildDetailRow('Description', item.productCst ?? 'N/A'),
                    _buildDetailRow('HSN Code', item.productIt ?? 'N/A'),
                    _buildDetailRow('Batch No', item.productLst ?? 'N/A'),
                    SizedBox(height: 8.h),
                    Divider(color: Colors.grey[200], thickness: 1),
                    SizedBox(height: 8.h),
                    _buildDetailRow('Quantity', item.quantity ?? 'N/A'),
                    _buildDetailRow('Rate', '₹${item.rate ?? '0'}'),
                    _buildDetailRow('Amount', '₹${item.amount ?? '0'}'),
                    _buildDetailRow('Discount', '${item.discount ?? '0'}%'),
                    _buildDetailRow(
                      'Total',
                      '₹${item.total ?? '0'}',
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isHighlight
                    ? Colours.primaryColor
                    : const Color(0xFF1A1A1A),
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingStep {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;

  _TrackingStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isCurrent,
  });
}
