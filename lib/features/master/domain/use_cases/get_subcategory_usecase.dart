import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/master/domain/entities/sub_category_entity.dart';

import '../../../../core/common/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/master_repository.dart';

class GetSubcategoryUsecase
    implements UseCase<List<SubcategoryEntity>, NoParams> {
  final MasterRepository repository;

  GetSubcategoryUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SubcategoryEntity>>> call(
    NoParams noParams,
  ) async {
    return await repository.getSubCategory("");
  }
}
