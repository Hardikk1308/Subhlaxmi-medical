import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/explore/data/models/product_model.dart';

import '../../../../core/constants/api_constants.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? categoryId});
  Future<ProductModel> getProductDetails({required String productCode});
  Future<ProductModel> getProductDetailsByCategory({
    required String productCode,
    required String categoryId,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    try {
      final uri = Uri.parse(ApiConstants.product);
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: categoryId != null ? {'cat_id': categoryId} : null,
      );

      appLog('POST ${ApiConstants.product}');
      appLog(
        'Request Body: ${categoryId != null ? {'cat_id': categoryId} : {}}',
      );
      appLog('Response Status: ${response.statusCode}');
      appLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        // API uses 'response' == 'success' and contains 'data' similar to other endpoints
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          final List<dynamic> jsonResponse = responseBody['data'];
          return jsonResponse.map((e) => ProductModel.fromJson(e)).toList();
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to get products',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to get products',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      appLog('ProductRemoteDataSourceImpl exception: $e');
      throw ServerException(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ProductModel> getProductDetails({required String productCode}) async {
    try {
      final uri = Uri.parse(ApiConstants.productDetails);
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'M1_CODE': productCode},
      );

      appLog('POST ${ApiConstants.productDetails}');
      appLog('Request Body: {M1_CODE: $productCode}');
      appLog('Response Status: ${response.statusCode}');
      appLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['response'] == 'success' &&
            responseBody.containsKey('data')) {
          final List<dynamic> jsonResponse = responseBody['data'];
          if (jsonResponse.isNotEmpty) {
            final product = ProductModel.fromJson(jsonResponse[0]);
            return product;
          } else {
            throw ServerException(
              message: 'Product not found',
              statusCode: response.statusCode,
            );
          }
        } else {
          throw ServerException(
            message: responseBody['message'] ?? 'Failed to get product details',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to get product details',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException {
      throw NetworkException(message: 'No internet connection', statusCode: 0);
    } catch (e) {
      appLog('ProductRemoteDataSourceImpl exception: $e');
      throw ServerException(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ProductModel> getProductDetailsByCategory({
    required String productCode,
    required String categoryId,
  }) async {
    try {
      // Fetch all products from the category
      final products = await getProducts(categoryId: categoryId);

      // Find the product with matching code
      final product = products.firstWhere(
        (p) => p.M1_CODE == productCode,
        orElse: () => throw ServerException(
          message: 'Product not found in category',
          statusCode: 404,
        ),
      );

      return product;
    } catch (e) {
      appLog(
        'ProductRemoteDataSourceImpl getProductDetailsByCategory exception: $e',
      );
      rethrow;
    }
  }
}
