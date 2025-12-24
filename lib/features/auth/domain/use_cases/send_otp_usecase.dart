import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/auth/domain/repositories/auth_repo.dart';

import '../../../../core/common/usecases/usecase.dart';

class SendOtpUseCase implements UseCase<String, String> {
  final AuthRepository repository;

  SendOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(String mobile) async {
    return await repository.sendOTP(mobile);
  }
}
