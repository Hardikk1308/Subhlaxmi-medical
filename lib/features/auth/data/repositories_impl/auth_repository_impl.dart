import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mediecom/features/auth/domain/repositories/auth_repo.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(String mobile) async {
    try {
      final user = await remoteDataSource.login(mobile);
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
  Future<Either<Failure, String>> sendOTP(String mobile) async {
    try {
      final user = await remoteDataSource.sendOTP(mobile);
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
  Future<Either<Failure, UserModel>> verifyOTP(
    String userId,
    String otp,
  ) async {
    try {
      final user = await remoteDataSource.verifyOTP(userId, otp);
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
}
