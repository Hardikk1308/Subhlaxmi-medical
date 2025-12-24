import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';

import '../../../../core/common/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UpdateFcmUsecase implements UseCase<void, UpdateFcmParams> {
  final UserRepository repository;

  UpdateFcmUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateFcmParams params) async {
    return await repository.updateFcm(params.userId, params.fcmToken);
  }
}

class UpdateFcmParams {
  final String userId;
  final String fcmToken;

  UpdateFcmParams({required this.userId, required this.fcmToken});
}
