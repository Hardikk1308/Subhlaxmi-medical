import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';
import 'package:mediecom/features/user/domain/repositories/user_repository.dart';

class UploadPhotoUseCase implements UseCase<UserEntity, UploadPhotoParams> {
  final UserRepository repository;

  UploadPhotoUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(UploadPhotoParams params) async {
    return await repository.updatePhoto(params.file);
  }
}

class UploadPhotoParams {
  final File file;

  UploadPhotoParams({required this.file});
}
