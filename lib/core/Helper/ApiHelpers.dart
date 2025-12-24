import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/utils/utils.dart';

class Apihelpers {
  final http.Client client;

  Apihelpers({required this.client});

  /// ==========================
  /// 🔹 POST Method
  /// ==========================
  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? accessToken,
    Map<String, dynamic>? params,
    bool isFormData = true,
  }) async {
    try {
      // 1️⃣ Build complete URL
      Uri uri = Uri.parse('$endpoint');
      if (params != null && params.isNotEmpty) {
        uri = uri.replace(
          queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
        );
      }

      // 2️⃣ Prepare headers
      final headers = {
        'Content-Type': isFormData
            ? 'application/x-www-form-urlencoded'
            : 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

      // 3️⃣ Log request details
      appLog('📤 POST: $uri');
      appLog('Headers: $headers');
      appLog('Body: $body');
      if (params != null) appLog('Params: $params');

      // 4️⃣ Send request
      final response = await client.post(
        uri,
        headers: headers,
        body: isFormData ? body : json.encode(body),
      );

      // 5️⃣ Log response
      appLog('📥 Status: ${response.statusCode}');
      // appLog('Response: ${response.body}');

      // 6️⃣ Handle response
      return _processResponse(response);
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// ==========================
  /// 🔹 GET Method
  /// ==========================
  Future<Map<String, dynamic>> get({
    required String endpoint,
    String? accessToken,
    Map<String, dynamic>? params,
  }) async {
    try {
      // 1️⃣ Build complete URL
      Uri uri = Uri.parse('$endpoint');
      if (params != null && params.isNotEmpty) {
        uri = uri.replace(
          queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
        );
      }

      // 2️⃣ Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

      // 3️⃣ Log request details
      appLog('📤 GET: $uri');
      appLog('Headers: $headers');

      // 4️⃣ Send request
      final response = await client.get(uri, headers: headers);

      // 5️⃣ Log response
      appLog('📥 Status: ${response.statusCode}');
      appLog('Response: ${response.body}');

      // 6️⃣ Handle response
      return _processResponse(response);
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// ==========================
  /// 🔹 Common Response Handler
  /// ==========================
  Map<String, dynamic> _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? json.decode(response.body) : {};

    if (statusCode >= 200 && statusCode < 300) {
      return {'success': true, 'statusCode': statusCode, 'data': body['data']};
    } else {
      final message = body['message'] ?? 'Request failed';
      throw ServerException(message: message, statusCode: statusCode);
    }
  }
}
