import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/explore/domain/entities/featured_entity..dart';
import 'package:mediecom/features/explore/domain/repositories/features_repository.dart';

import '../../../../core/common/usecases/usecase.dart';

class FetchFeaturesUsecase implements UseCase<List<FeaturesEntity>, NoParams> {
  final FeaturesRepository repository;

  FetchFeaturesUsecase({required this.repository});

  @override
  Future<Either<Failure, List<FeaturesEntity>>> call(NoParams noParams) async {
    return await repository.getFeatured();
  }
}
