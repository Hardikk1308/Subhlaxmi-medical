import 'package:equatable/equatable.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';

class ProductDetailsArgs extends Equatable {
  final String tag;
  final ProductEntity cate;
  final String? categoryId;

  ProductDetailsArgs({
    required this.cate,
    required this.tag,
    this.categoryId,
  });

  @override
  List<Object?> get props => [tag, cate, categoryId];
}
