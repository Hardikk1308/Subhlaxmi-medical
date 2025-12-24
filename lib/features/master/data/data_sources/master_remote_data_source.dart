import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/master/data/models/category_model.dart';
import 'package:mediecom/features/master/data/models/slider_model.dart';
import 'package:mediecom/features/master/data/models/sub_category_model.dart';
import 'package:mediecom/features/master/domain/entities/sub_category_entity.dart';

import '../../../../core/constants/api_constants.dart';

abstract class MasterRemoteDataSource {
  Future<List<SliderModel>> getBanners();

  Future<List<CategoryModel>> getCategory();

  // Future<List<NestedCategoryModel>> getNestedSubCategories();

  Future<List<SubcategoryEntity>> getSubCategory(String catId);
}

class MasterRemoteDataSourceImpl implements MasterRemoteDataSource {
  final http.Client client;

  MasterRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SliderModel>> getBanners() async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.slider),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      appLog('GET ${ApiConstants.slider}');
      log(
        'Request Headers: ${json.encode({'Content-Type': 'application/x-www-form-urlencoded'})}',
      );
      appLog('Response Status: ${response.statusCode}');
      appLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          final List<dynamic> jsonResponse = json.decode(response.body)['data'];
          return jsonResponse
              .map((json) => SliderModel.fromJson(json))
              .toList();
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to get data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to get data',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<CategoryModel>> getCategory() async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.category),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      appLog('GET ${ApiConstants.category}');
      log(
        'Request Headers: ${json.encode({'Content-Type': 'application/x-www-form-urlencoded'})}',
      );
      appLog('Response Status: ${response.statusCode}');
      appLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          final List<dynamic> jsonResponse = json.decode(response.body)['data'];
          return jsonResponse
              .map((json) => CategoryModel.fromJson(json))
              .toList();
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to get data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to get data',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  // @override
  // Future<List<NestedCategoryModel>> getNestedSubCategories() async {
  //   try {
  //     final response = await client.post(
  //       Uri.parse(ApiConstants.getNestedSubCategories),
  //       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //     );

  //     appLog('GET ${ApiConstants.getNestedSubCategories}');
  //     log(
  //       'Request Headers: ${json.encode({'Content-Type': 'application/x-www-form-urlencoded'})}',
  //     );
  //     appLog('Response Status: ${response.statusCode}');
  //     appLog('Response Body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseBody = json.decode(response.body);
  //       if (responseBody['response'] == 'success' &&
  //           responseBody.containsKey('data')) {
  //         final List<dynamic> jsonResponse = json.decode(response.body)['data'];
  //         return jsonResponse
  //             .map((json) => NestedCategoryModel.fromJson(json))
  //             .toList();
  //       } else {
  //         throw ServerException(
  //           message: responseBody['message'] ?? 'Failed to get data',
  //           statusCode: response.statusCode,
  //         );
  //       }
  //     } else {
  //       throw ServerException(
  //         message: 'Failed to get data',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on http.ClientException {
  //     throw NetworkException(message: 'No internet connection', statusCode: 0);
  //   } catch (e) {
  //     throw ServerException(
  //       message: 'Unexpected error occurred',
  //       statusCode: 500,
  //     );
  //   }
  // }

  @override
  Future<List<SubcategoryEntity>> getSubCategory(String catId) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.subcategory),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'category_id': catId},
      );

      appLog('GET ${ApiConstants.subcategory}');
      appLog(
        'Request Headers: ${json.encode({'Content-Type': 'application/x-www-form-urlencoded'})}',
      );
      appLog('Request Body: ${{'category_id': catId}}');

      appLog('Response Status: ${response.statusCode}');
      appLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          final List<dynamic> jsonResponse = json.decode(response.body)['data'];
          return jsonResponse
              .map((json) => SubcategoryModel.fromJson(json))
              .toList();
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to get data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to get data',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }
}
