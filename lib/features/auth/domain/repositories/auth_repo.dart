import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String mobile);

  Future<Either<Failure, String>> sendOTP(String mobile);

  Future<Either<Failure, UserModel>> verifyOTP(String userId, String otp);
}
