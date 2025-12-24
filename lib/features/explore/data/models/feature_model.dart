import 'package:mediecom/features/explore/data/models/product_model.dart';
import 'package:mediecom/features/explore/domain/entities/featured_entity..dart';
import 'package:mediecom/features/master/data/models/category_model.dart';

class FeaturesModel extends FeaturesEntity {
  const FeaturesModel({
    required super.name,
    required super.lname,
    required super.type,
    super.categories,
    super.products,
  });

  factory FeaturesModel.fromJson(Map<String, dynamic> json) {
    final type = json['M1_TYPE1']?.toString() ?? '';

    return FeaturesModel(
      name: json['M1_NAME']?.toString() ?? '',
      lname: json['M1_LNAME']?.toString() ?? '',
      type: type,

      // --- FIXED ---
      categories: type == 'ProductCategory'
          ? (json['ProductCategory'] as List<dynamic>? ?? [])
                .map((e) => CategoryModel.fromJson(e))
                .toList()
          : null,

      // --- FIXED ---
      products: type == 'Product'
          ? (json['Product'] as List<dynamic>? ?? [])
                .map((e) => ProductModel.fromJson(e))
                .toList()
          : null,
    );
  }
}
