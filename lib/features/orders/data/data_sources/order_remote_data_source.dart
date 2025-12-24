import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/constants/api_constants.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/orders/data/models/order_details_model.dart';
import 'package:mediecom/features/orders/data/models/order_history_model.dart';
import 'package:mediecom/features/orders/data/models/orders_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrdersModel>> fetchOrderList(String userId);
  Future<OrderDetailsModel> fetchOrderDetails(String orderId);
  Future<List<OrderHistoryModel>> fetchOrderHistory(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<String> insertOrder(Map<String, dynamic> orderData);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;

  OrderRemoteDataSourceImpl({required this.client});

  @override
  Future<List<OrdersModel>> fetchOrderList(String userId) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.orderList),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_id': userId},
      );

      _logApiCall('fetchOrderList', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          final List<dynamic> data = responseBody['data'];
          return data.map((e) => OrdersModel.fromJson(e)).toList();
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to fetch orders',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<OrderDetailsModel> fetchOrderDetails(String orderId) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.orderDetails),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'F4_NO': orderId},
      );

      _logApiCall('fetchOrderDetails', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          return OrderDetailsModel.fromJson(responseBody['data'][0]);
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to fetch order details',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<OrderHistoryModel>> fetchOrderHistory(String orderId) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.orderHistoryList),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'F4_LCODE': orderId},
      );

      _logApiCall('fetchOrderHistory', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          final List<dynamic> data = responseBody['data'];
          return data.map((e) => OrderHistoryModel.fromJson(e)).toList();
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to fetch order history',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.updateOrderStatus),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'order_id': orderId, 'status': status},
      );

      _logApiCall('updateOrderStatus', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] != 'success') {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to update order status',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<String> insertOrder(Map<String, dynamic> payload) async {
    try {
      final String pm = payload['F4_PM'] ?? '';
      final orderData = payload['payload'] as Map<String, dynamic>;

      appLog(pm);

      // Build the request body matching the API requirements
      final Map<String, dynamic> body = {
        "user_id": "${orderData['user_id']}",
        "F4_PARTY[]": orderData['F4_PARTY'].toString(), // product IDs
        "F4_QTY[]": orderData['F4_QTY'].toString(), // quantities
        "subtotal": "${orderData['sub_total'] ?? orderData['subtotal'] ?? orderData['grand_total'] ?? 0}",
        "coupon_id": "${payload['coupon_id'] ?? ''}",
        "tax": "${payload['tax'] ?? 0}",
        "tax_amt": "${payload['tax_amt'] ?? 0}",
        "discount": "${payload['discount'] ?? 0}",
        "discount_amt": "${payload['discount_amt'] ?? 0}",
        "delivery_charge": "${payload['delivery_charge'] ?? 0}",
        "grand_total": "${payload['grand_total'] ?? orderData['grand_total'] ?? 0}",
      };

      appLog("Insert Order Payload: $body");

      final response = await client.post(
        Uri.parse(ApiConstants.insertOrder),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      _logApiCall('insertOrder', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['response'] == 'success') {
          final data = responseBody['data'];
          final String orderId = data[0]['F4_NO'].toString();
          return orderId;
        }
        if (responseBody['response'] != 'success') {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to insert order',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      appLog("msg" + e.toString());

      throw ServerException(message: e.toString(), statusCode: 500);
    }
    throw ServerException(message: "Error Inserting Order", statusCode: 500);
  }

  void _logApiCall(String method, http.Response response) {
    appLog('POST ${response.request?.url}');
    appLog('Method: $method');
    appLog('Status: ${response.statusCode}');
    appLog('Response: ${response.body}');
  }

  void _handleError(dynamic e) {
    if (e is http.ClientException) {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } else if (e is ServerException) {
      throw e;
    } else {
      appLog('Unexpected error: $e');
      throw ServerException(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
