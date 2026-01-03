import 'package:mediecom/core/Helper/ApiHelpers.dart';
import 'package:mediecom/core/constants/api_constants.dart';
import 'package:mediecom/features/explore/data/models/feature_model.dart';
import 'package:mediecom/features/explore/data/models/product_model.dart';
import 'package:mediecom/features/explore/domain/entities/featured_entity..dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';

abstract class FeatureRemoteDataSource {
  Future<List<FeaturesEntity>> getFeatured();
  Future<List<ProductEntity>> search(String query);
}

class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final Apihelpers apihelpers;

  FeatureRemoteDataSourceImpl({required this.apihelpers});

  @override
  Future<List<FeaturesEntity>> getFeatured() async {
    try {
      final response = await apihelpers.post(
        endpoint: ApiConstants.features,
        body: {},
      );

      if (response["success"] == true) {
        final List<dynamic> dataList = response["data"];

        return dataList.map((json) => FeaturesModel.fromJson(json)).toList();
      } else {
        throw Exception(response["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductEntity>> search(String query) async {
    try {
      final response = await apihelpers.post(
        endpoint: ApiConstants.search,
        body: {'query': query},
      );

      if (response["success"] == true) {
        final List<dynamic> dataList = response["data"];
        List<ProductEntity> products = dataList.map((json) => ProductModel.fromJson(json)).toList();
        
        // Fetch full details for each product to get expire dates
        List<ProductEntity> productsWithDetails = [];
        for (var product in products) {
          try {
            final detailResponse = await apihelpers.post(
              endpoint: ApiConstants.productDetails,
              body: {'M1_CODE': product.M1_CODE},
            );
            
            if (detailResponse["success"] == true && detailResponse["data"] != null && detailResponse["data"].isNotEmpty) {
              productsWithDetails.add(ProductModel.fromJson(detailResponse["data"][0]));
            } else {
              productsWithDetails.add(product);
            }
          } catch (e) {
            // If detail fetch fails, use the search result
            productsWithDetails.add(product);
          }
        }
        
        return productsWithDetails;
      } else {
        throw Exception(response["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
