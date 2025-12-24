import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';
import 'package:mediecom/features/user/domain/repositories/user_repository.dart';

class UpdateUserDetailsUsecase
    implements UseCase<UserModel, UpdateUserDetailsParams> {
  final UserRepository repository;

  UpdateUserDetailsUsecase({required this.repository});

  @override
  Future<Either<Failure, UserModel>> call(
    UpdateUserDetailsParams params,
  ) async {
    return await repository.updateProfile(params.user);
  }
}

class UpdateUserDetailsParams {
  final UserModel user;

  UpdateUserDetailsParams({required this.user});
}
