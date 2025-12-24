import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';

import '../../../../core/common/usecases/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/master_repository.dart';

class GetCategoryUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final MasterRepository repository;

  GetCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams noParams) async {
    return await repository.getCategory();
  }
}
