import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/auth/domain/repositories/auth_repo.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';

class LoginUseCase implements UseCase<UserEntity, String> {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(String mobile) async {
    return await repository.login(mobile);
  }
}
