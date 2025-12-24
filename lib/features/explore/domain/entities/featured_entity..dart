import 'package:equatable/equatable.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';
import 'package:mediecom/features/master/domain/entities/category_entity.dart';

class FeaturesEntity extends Equatable {
  final String name;
  final String lname;
  final String type;

  final List<CategoryEntity>? categories;
  final List<ProductEntity>? products;

  const FeaturesEntity({
    required this.name,
    required this.lname,
    required this.type,
    this.categories,
    this.products,
  });

  @override
  List<Object?> get props => [name, lname, categories, products];
}
