import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediecom/core/common/app/application_details.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentWidget extends StatefulWidget {
  final int amount;
  final void Function(String orderId) onSuccess;
  final VoidCallback onFailure;

  const RazorpayPaymentWidget({
    super.key,
    required this.amount,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  State<RazorpayPaymentWidget> createState() => _RazorpayPaymentWidgetState();
}

class _RazorpayPaymentWidgetState extends State<RazorpayPaymentWidget> {
  late Razorpay razorpay;
  bool isLoading = false;

  final appData = ApplicationRepository().applicationData;

  @override
  void initState() {
    super.initState();

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _paymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _paymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _walletHandler);
  }

  void _paymentSuccess(PaymentSuccessResponse response) async {
    bool verified = await verifyPayment(
      response.paymentId!,
      response.orderId!,
      response.signature!,
    );

    if (verified) {
      widget.onSuccess(
        response.orderId!,
      ); // place order only if payment verified
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment verification failed!")),
      );
      widget.onFailure();
    }
  }

  void _paymentError(PaymentFailureResponse response) {
    widget.onFailure();
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  // -------------------------------
  // 1️⃣ Call PHP API to create order
  // -------------------------------
  Future<String?> createOrder() async {
    setState(() => isLoading = true);
    try {
      final url = Uri.parse(
        'https://www.subhlaxmimedical.com/myadmin/Razor_Api/create_order',
      ); // use LAN IP / HTTPS in device
      final response = await http
          .post(url, body: {'payable_amount': widget.amount.toString()})
          .timeout(const Duration(seconds: 15));

      print('createOrder status: ${response.statusCode}');
      print('createOrder body: ${response.body}');

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error ${response.statusCode}')),
        );
        return null;
      }

      // Try parse JSON safely
      dynamic json;
      try {
        json = jsonDecode(response.body);
      } catch (e) {
        // got HTML or unexpected — show raw for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid server response')),
        );
        print('Invalid JSON from createOrder: ${response.body}');
        return null;
      }

      // adapt to your backend response keys
      if (json != null &&
          (json['response'] == 'success' || json['status'] == true)) {
        // Some backends return id vs order_id
        final id = json['id'] ?? json['order_id'] ?? json['orderId'];
        return id?.toString();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Create order failed: ${json['message'] ?? response.body}',
            ),
          ),
        );
        return null;
      }
    } on Exception catch (e) {
      print('createOrder error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Network error: $e')));
      return null;
    } finally {
      setState(() => isLoading = false);
    }
  }

  // -------------------------------
  // 2️⃣ Open Razorpay Checkout
  // -------------------------------
  void openCheckout(String orderId) {
    final options = {
      'key': 'rzp_test_DzhOHKz9K9wtLY', // your Razorpay key
      'amount': widget.amount * 100,
      'name': appData?.name ?? 'Subhlaxmi Medical',
      'order_id': orderId,
      'description': 'Order Payment',
      'timeout': 120,
      'prefill': {'contact': appData?.contactNumber, 'email': appData?.email},
    };

    razorpay.open(options);
  }

  // ---------------------------------------
  // 3️⃣ Verify payment with your PHP backend
  // ---------------------------------------
  Future<bool> verifyPayment(String pid, String oid, String sign) async {
    final url = Uri.parse("https://yourdomain.com/verify_signature.php");

    try {
      final response = await http.post(
        url,
        body: {
          "razorpay_payment_id": pid,
          "razorpay_order_id": oid,
          "razorpay_signature": sign,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      } else {
        return false;
      }
    } catch (e) {
      print("verifyPayment error: $e");
      return false;
    }
  }

  // -------------------------------
  // Razorpay Callbacks
  // -------------------------------
  // void _paymentSuccess(PaymentSuccessResponse response) async {
  //   await verifyPayment(
  //     response.paymentId!,
  //     response.orderId!,
  //     response.signature!,
  //   );
  // }

  // void _paymentError(PaymentFailureResponse response) {
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(const SnackBar(content: Text("Payment Failed")));
  // }

  void _walletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Wallet: ${response.walletName}")));
  }

  // -------------------------------
  // 📌 UI Button
  // -------------------------------
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final orderId = await createOrder();
              if (orderId != null) openCheckout(orderId);
            },
            child: Text(
              "Pay Now",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          );
  }
}
