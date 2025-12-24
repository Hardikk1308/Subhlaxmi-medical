import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';
import 'package:mediecom/features/explore/domain/repositories/product_repository.dart';

class GetProductDetailsUseCase {
  final ProductRepository repository;
  GetProductDetailsUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call({
    required String productCode,
  }) async {
    return await repository.getProductDetails(productCode: productCode);
  }

  Future<Either<Failure, ProductEntity>> callByCategory({
    required String productCode,
    required String categoryId,
  }) async {
    return await repository.getProductDetailsByCategory(
      productCode: productCode,
      categoryId: categoryId,
    );
  }
}
