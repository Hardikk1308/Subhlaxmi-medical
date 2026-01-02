import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/utils/utils.dart';

import '../../../../core/constants/api_constants.dart';

import '../../../../injection_container.dart';
import '../../../user/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> fetchUserDetails(String userId);
  Future<UserModel> updateProfile(UserModel user);
  Future<UserModel> updatePhoto(File photoPath);
  Future<void> updateFcm(String userId, String fcmToken);
  Future<List<Map<String, dynamic>>> getNotifications(String userId);
  Future<String> uploadPrescription(List<File> images);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> fetchUserDetails(String userId) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.userDetails),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_id': userId},
      );

      _logApiCall('fetchUserDetails', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          return UserModel.fromJson(responseBody['data'][0]);
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to fetch user details',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    final cacheHelper = sl<CacheHelper>();
    try {
      final body = {
        "user_id": cacheHelper.getUserId() ?? "",
        "user_name": user.m2Chk1 ?? "",
        "user_mobile": user.m2Chk2 ?? "",
        "user_email": user.m2Chk3 ?? "",
        "user_dob": user.m2Chk5 ?? "",
        "user_gender": user.m2Chk6 ?? "",
        "user_address": user.m2Chk7 ?? "",
        "user_state": user.m2Chk8 ?? "",
        "user_city": user.m2Chk9 ?? "",
        "user_referral": user.m2Chk25 ?? "",
      };
      final profileResponse = await client.post(
        Uri.parse(ApiConstants.updateProfile),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      // _logApiCall("update_profile:RequestBody", body.to);
      appLog(" update_profile:RequestBody $body");
      _logApiCall('updateProfile:ResponseBody', profileResponse);
      appLog(" update_photo:RequestBody $profileResponse");

      if (profileResponse.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(
          profileResponse.body,
        );
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          return UserModel.fromJson(responseBody['data'][0]);
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to update profile',
            statusCode: profileResponse.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: profileResponse.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  @override
  Future<UserModel> updatePhoto(File photoPath) async {
    try {
      final path = photoPath.path;
      final cacheHelper = sl<CacheHelper>();
      final String userId = cacheHelper.getUserId() ?? "";

      final request =
          http.MultipartRequest('POST', Uri.parse(ApiConstants.updatePhoto))
            ..fields['user_id'] = userId
            ..files.add(await http.MultipartFile.fromPath('user_pic', path));

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      _logApiCall('updatePhoto', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          return UserModel.fromJson(responseBody['data'][0]);
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to update photo',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  @override
  Future<void> updateFcm(String userId, String fcmToken) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.updateFcm),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_id': userId, 'fcm_token': fcmToken},
      );

      _logApiCall('updateFcm', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] != 'success') {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to update FCM token',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.notification),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_id': userId},
      );

      _logApiCall('getNotifications', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          final List<dynamic> data = responseBody['data'];
          return List<Map<String, dynamic>>.from(data);
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to fetch notifications',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _logApiCall(String method, http.Response response) {
    appLog('POST ${response.request?.url}');
    appLog('Method: $method');
    appLog('Status: ${response.statusCode}');
    appLog('Response: ${response.body}');
  }

  void _handleError(dynamic e) {
    if (e is ServerException) {
      throw e;
    } else {
      appLog('Unexpected error: $e');
      throw ServerException(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<String> uploadPrescription(List<File> images) async {
    try {
      final cacheHelper = sl<CacheHelper>();
      final String userId = cacheHelper.getUserId() ?? "";

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.insertPrescription),
      );

      request.fields['user_id'] = userId;

      // Map incoming images to backend fields dynamically
      final fieldNames = ['F4_TXT1', 'F4_TXT2', 'F4_TXT3'];

      for (int i = 0; i < images.length && i < 3; i++) {
        final file = images[i];
        request.files.add(
          await http.MultipartFile.fromPath(fieldNames[i], file.path),
        );
      }

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      _logApiCall('insertPrescription', response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['response'] == 'success') {
          return responseBody['message'];
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to upload prescription',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Server error',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }
}
