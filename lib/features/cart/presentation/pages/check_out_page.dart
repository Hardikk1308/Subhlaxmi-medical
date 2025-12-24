import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/style/app_text_styles.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/cart/presentation/pages/order_confirmation_page.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_event.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_state.dart';
import 'package:mediecom/features/payment_gateway.dart';
import 'package:mediecom/injection_container.dart';

class PaymentMethodPage extends StatefulWidget {
  static const path = '/payment-method';
  final Map<String, dynamic>? payload;
  const PaymentMethodPage({super.key, this.payload});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int selectedMethod = 0; // 0 = Online, 1 = COD
  bool _isProcessingPayment = false;

  void _handleOnlinePayment() {
    setState(() => _isProcessingPayment = true);

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            // Secure Payment Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.teal,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              "Complete Your Payment",
              style: AppTextStyles.w700(
                20,
              ).copyWith(color: Colors.grey.shade900),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              "You're almost there! Complete the payment to confirm your order",
              textAlign: TextAlign.center,
              style: AppTextStyles.w500(
                14,
              ).copyWith(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            // Amount Display Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.teal.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Total Amount",
                    style: AppTextStyles.w500(
                      13,
                    ).copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹${widget.payload!['totalAmount']}",
                    style: AppTextStyles.w700(
                      28,
                    ).copyWith(color: Colors.teal.shade700),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Methods Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _paymentMethodIcon(Icons.credit_card),
                const SizedBox(width: 16),
                _paymentMethodIcon(Icons.account_balance),
                const SizedBox(width: 16),
                _paymentMethodIcon(Icons.phone_android),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "UPI • Cards • Net Banking • Wallets",
              style: AppTextStyles.w500(
                12,
              ).copyWith(color: Colors.grey.shade500),
            ),

            const SizedBox(height: 28),

            // Custom Pay Now Button (matching theme)
            _buildCustomPayButton(
              onPressed: () async {
                // Get the button's build method to trigger payment
                // This will call createOrder() and openCheckout()
              },
            ),

            const SizedBox(height: 16),

            // Secure Payment Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  "Safe & Secure Payment",
                  style: AppTextStyles.w500(
                    12,
                  ).copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    ).whenComplete(() {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    });
  }

  // Payment Method Icon Widget
  Widget _paymentMethodIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, size: 24, color: Colors.grey.shade700),
    );
  }

  // Custom Pay Button matching the theme
  Widget _buildCustomPayButton({required VoidCallback onPressed}) {
    return Builder(
      builder: (context) {
        return RazorpayPaymentWidget(
          amount: (widget.payload!['totalAmount'] as num).toInt(),
          onSuccess: (orderId) {
            Navigator.pop(context);
            context.read<OrdersBloc>().add(
              InsertOrderEvent(
                orderData: {
                  'F4_PM': "Online",
                  'order_id': orderId,
                  'payload': widget.payload!['cartPayload'],
                  'subtotal': widget.payload!['subtotal'] ?? 0,
                  'tax': 0,
                  'tax_amt': 0,
                  'discount': 0,
                  'discount_amt': 0,
                  'delivery_charge': widget.payload!['deliveryFee'] ?? 0,
                  'grand_total': widget.payload!['totalAmount'] ?? 0,
                },
              ),
            );
          },
          onFailure: () {
            Navigator.pop(context);
            setState(() => _isProcessingPayment = false);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Payment failed!")));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    appLog("PaymentMethodPage Payload: ${widget.payload}");
    return Scaffold(
      backgroundColor: const Color(0xFFE0F4F6),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE0F4F6),
        foregroundColor: Colors.black,
        title: Text("Payment Method", style: AppTextStyles.w600(16)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),

      bottomNavigationBar: _buildBottomButton(
        "₹${widget.payload?['totalAmount'].toString()}" ?? "₹0.00",
      ),

      body: BlocListener<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state is OrderInsertSuccess) {
            setState(() => _isProcessingPayment = false);

            // Refresh order list and fetch order details
            final cacheHelper = sl<CacheHelper>();
            final userId = cacheHelper.getUserId() ?? "";
            
            // Fetch the newly created order details
            context.read<OrdersBloc>().add(
              FetchOrderDetailsEvent(orderId: state.orderId),
            );
            
            // Also refresh the order list
            context.read<OrdersBloc>().add(FetchOrderListEvent(userId: userId));

            // Navigate to Order Confirmation Page
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.pushReplacement(
                  OrderConfirmationPage.path,
                  extra: state.orderId,
                );
              }
            });
          } else if (state is OrdersFailure) {
            setState(() => _isProcessingPayment = false);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error placing order: ${state.message}")),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose a payment method", style: AppTextStyles.w600(16)),

              const SizedBox(height: 16),

              _paymentCard(
                index: 0,
                icon: Icons.credit_card_rounded,
                title: "Online Payment",
                subtitle: "Credit/Debit Card, UPI, Net Banking",
              ),

              const SizedBox(height: 12),

              _paymentCard(
                index: 1,
                icon: Icons.wallet_rounded,
                title: "Cash on Delivery",
                subtitle: "Pay with cash upon delivery",
              ),

              const SizedBox(height: 16),

              _securePaymentBadge(),
              const SizedBox(height: 20),

              _couponField(),
              const SizedBox(height: 20),

              _priceDetails(
                "₹${widget.payload?['subtotal'].toString()}" ?? "₹0.00",
                "₹${widget.payload?['deliveryFee'].toString()}" ?? "₹0.00",
                widget.payload?['discount'] ?? "₹0.00",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------- COUPEN CARD -------------------------

  Widget _couponField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter coupon code",
                hintStyle: AppTextStyles.w500(
                  14,
                ).copyWith(color: Colors.grey.shade500),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.teal, width: 1.5),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // TODO: Apply coupon logic
            },
            child: Text(
              "Apply",
              style: AppTextStyles.w600(14).copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------- PAYMENT CARD -------------------------

  Widget _paymentCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = selectedMethod == index;

    return InkWell(
      onTap: () => setState(() => selectedMethod = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.grey.shade700),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.w600(
                      16,
                    ).copyWith(color: Colors.grey.shade900),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.w500(
                      13,
                    ).copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.teal : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------- SECURE PAYMENT -------------------------

  Widget _securePaymentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user, color: Colors.teal),
          const SizedBox(width: 8),
          Text(
            "100% Secure Payments",
            style: AppTextStyles.w600(15).copyWith(color: Colors.teal),
          ),
        ],
      ),
    );
  }

  // ------------------------- PRICE DETAILS -------------------------

  Widget _priceDetails(String subtotal, String deliveryFee, String discount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price Details", style: AppTextStyles.w700(17)),

          const SizedBox(height: 14),

          _priceRow("Subtotal", subtotal),
          _priceRow("Delivery Fee", deliveryFee),
          _priceRow("Discount", discount, valueColor: Colors.green),

          const Divider(height: 28),

          _priceRow(
            "Total Amount",
            "${widget.payload?['totalAmount'] != null ? "₹${widget.payload!['totalAmount']}" : "₹0.00"}",
            isBold: true,
            valueColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.w500(14).copyWith(
              color: Colors.grey.shade700,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: (isBold ? AppTextStyles.w700(15) : AppTextStyles.w500(15))
                .copyWith(color: valueColor ?? Colors.black87),
          ),
        ],
      ),
    );
  }

  // ------------------------- BOTTOM BUTTON -------------------------

  Widget _buildBottomButton(String totalAmount) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _isProcessingPayment
              ? null
              : () {
                  if (selectedMethod == 0) {
                    // Online Payment - Show bottom sheet with payment button
                    _handleOnlinePayment();
                  } else {
                    // COD → directly place order with loading state
                    setState(() => _isProcessingPayment = true);
                    context.read<OrdersBloc>().add(
                      InsertOrderEvent(
                        orderData: {
                          'F4_PM': "COD",
                          'payload': widget.payload!['cartPayload'],
                          'subtotal': widget.payload!['subtotal'] ?? 0,
                          'tax': 0,
                          'tax_amt': 0,
                          'discount': 0,
                          'discount_amt': 0,
                          'delivery_charge': widget.payload!['deliveryFee'] ?? 0,
                          'grand_total': widget.payload!['totalAmount'] ?? 0,
                        },
                      ),
                    );
                  }
                },
          child: _isProcessingPayment
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  "Place Order $totalAmount",
                  style: AppTextStyles.w600(16).copyWith(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
