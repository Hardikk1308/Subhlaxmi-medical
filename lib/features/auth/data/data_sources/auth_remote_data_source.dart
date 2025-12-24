import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/utils/utils.dart';

import '../../../../core/constants/api_constants.dart';

import '../../../user/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String mobile);

  Future<String> sendOTP(String mobile);

  Future<UserModel> verifyOTP(String userId, String otp);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String mobile) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.signUp),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_mobile': mobile},
      );

      appLog('POST ${ApiConstants.signUp}');
      appLog(
        'Request Headers: ${{'Content-Type': 'application/x-www-form-urlencoded'}}',
      );
      appLog('Request Body: ${{'user_mobile': mobile}}');
      appLog('Response Status: ${response.statusCode}');
      appLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          return UserModel.fromJson(responseBody['data'][0]);
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Login failed',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to login',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      appLog('Unexpected error: $e');
      throw ServerException(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  @override
  Future<String> sendOTP(String mobile) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.sendOtp),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_mobile': mobile},
      );

      appLog('POST ${ApiConstants.sendOtp}');
      log(
        'Request Headers: ${{'Content-Type': 'application/x-www-form-urlencoded'}}',
      );
      appLog('Request Body: ${{'user_mobile': mobile}}');
      appLog('Response Status: ${response.statusCode}');
      appLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success') {
          if (responseBody['user'] == null) {
            final user = await login(mobile);
            return user.m2Id ?? "";
          }
          return responseBody["user"];
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to send OTP',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to send OTP',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      appLog('Unexpected error: $e');
      throw ServerException(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  @override
  Future<UserModel> verifyOTP(String userId, String otp) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.verifyOtp),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_id': userId, 'otp': otp},
      );

      appLog('POST ${ApiConstants.verifyOtp}');
      log(
        'Request Headers: ${{'Content-Type': 'application/x-www-form-urlencoded'}}',
      );
      appLog('Request Body: ${{'user_id': userId, 'otp': otp}}');
      appLog('Response Status: ${response.statusCode}');
      appLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success') {
          return UserModel.fromJson(responseBody['user'][0]);
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to verify OTP',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to verify OTP',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      appLog('Unexpected error: $e');
      throw ServerException(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
