import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/master/domain/entities/slider_entity.dart';

import '../../../../core/common/usecases/usecase.dart';
import '../repositories/master_repository.dart';

class GetBannerUseCase implements UseCase<List<SliderEntity>, NoParams> {
  final MasterRepository repository;

  GetBannerUseCase({required this.repository});

  @override
  Future<Either<Failure, List<SliderEntity>>> call(NoParams noParams) async {
    return await repository.getBanners();
  }
}
