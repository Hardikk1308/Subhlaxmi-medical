import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/user/domain/repositories/user_repository.dart';

class UploadPrescriptionUsecase implements UseCase<String, UploadPrescription> {
  final UserRepository repository;

  UploadPrescriptionUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(UploadPrescription params) async {
    return await repository.uploadPrescription(params.file);
  }
}

class UploadPrescription {
  final List<File> file;

  UploadPrescription({required this.file});
}
