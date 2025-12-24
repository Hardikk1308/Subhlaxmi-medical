import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/notification/domain/entities/notif_entity.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> fetchUserDetails(String mobile);

  Future<Either<Failure, UserModel>> updateProfile(UserModel user);

  Future<Either<Failure, UserEntity>> updatePhoto(File photoPath);

  Future<Either<Failure, String>> uploadPrescription(List<File> images);

  Future<Either<Failure, void>> updateFcm(String userId, String fcmToken);

  Future<Either<Failure, List<NotifEntity>>> getNotifications(String userId);
}
