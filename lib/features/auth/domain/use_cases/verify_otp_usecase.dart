import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/auth/domain/repositories/auth_repo.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';

class VerifyOtpUseCase implements UseCase<UserModel, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, UserModel>> call(VerifyOtpParams params) async {
    return await repository.verifyOTP(params.userId, params.otp);
  }
}

class VerifyOtpParams {
  final String userId;
  final String otp;

  VerifyOtpParams({required this.userId, required this.otp});
}
