import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/notification/data/models/notification_model.dart';
import 'package:mediecom/features/notification/domain/entities/notif_entity.dart';
import 'package:mediecom/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';
import 'package:mediecom/features/user/domain/repositories/user_repository.dart';

class UserRepoImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> fetchUserDetails(String mobile) async {
    try {
      final user = await remoteDataSource.fetchUserDetails(mobile);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile(UserModel userModel) async {
    try {
      final user = await remoteDataSource.updateProfile(userModel);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while updating profile',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updatePhoto(File photoPath) async {
    try {
      final user = await remoteDataSource.updatePhoto(photoPath);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while updating photo',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateFcm(
    String userId,
    String fcmToken,
  ) async {
    try {
      await remoteDataSource.updateFcm(userId, fcmToken);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while updating FCM token',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<NotifEntity>>> getNotifications(
    String userId,
  ) async {
    try {
      final notifications = await remoteDataSource.getNotifications(userId);
      final notificationEntities = notifications
          .map((json) => NotificationModel.fromJson(json))
          .toList();
      return Right(notificationEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while fetching notifications',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> uploadPrescription(List<File> images) async {
    try {
      final message = await remoteDataSource.uploadPrescription(images);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return const Left(
        UnexpectedFailure(
          message: 'Unexpected error occurred while updating prescription',
          statusCode: 500,
        ),
      );
    }
  }
}
