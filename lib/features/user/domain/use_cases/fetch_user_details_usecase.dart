import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';
import 'package:mediecom/features/user/domain/repositories/user_repository.dart';

class FetchUserDetailsUsecase implements UseCase<UserEntity, String> {
  final UserRepository repository;

  FetchUserDetailsUsecase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(String userId) async {
    return await repository.fetchUserDetails(userId);
  }
}
