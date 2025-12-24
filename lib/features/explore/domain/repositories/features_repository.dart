import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/explore/domain/entities/featured_entity..dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';

abstract class FeaturesRepository {
  Future<Either<Failure, List<FeaturesEntity>>> getFeatured();
  Future<Either<Failure, List<ProductEntity>>> search(String query);
}
