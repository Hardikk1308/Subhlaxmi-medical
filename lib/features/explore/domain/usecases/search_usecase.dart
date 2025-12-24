import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';
import 'package:mediecom/features/explore/domain/repositories/features_repository.dart';

import '../../../../core/common/usecases/usecase.dart';

class SearchUsecase implements UseCase<List<ProductEntity>, String> {
  final FeaturesRepository repository;

  SearchUsecase({required this.repository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(String query) async {
    return await repository.search(query);
  }
}
