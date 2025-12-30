import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/constants/api_constants.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/account_review/data/models/company_model.dart';

abstract class AccountReviewRemoteDataSource {
  Future<CompanyModel> checkAccountStatus(String userId);
}

class AccountReviewRemoteDataSourceImpl implements AccountReviewRemoteDataSource {
  final http.Client client;

  AccountReviewRemoteDataSourceImpl({required this.client});

  @override
  Future<CompanyModel> checkAccountStatus(String userId) async {
    try {
      // Call user_details endpoint to get M2_BT status
      final response = await client.post(
        Uri.parse(ApiConstants.userDetails),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_id': userId},
      );

      appLog('POST ${ApiConstants.userDetails}');
      appLog('Request Body: ${{'user_id': userId}}');
      appLog('Response Status: ${response.statusCode}');
      appLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data') &&
            (responseBody['data'] as List).isNotEmpty) {
          return CompanyModel.fromJson(responseBody['data'][0]);
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to check account status',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to check account status',
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
