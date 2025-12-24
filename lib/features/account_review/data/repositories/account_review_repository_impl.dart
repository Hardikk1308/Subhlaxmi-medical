import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/account_review/data/data_sources/account_review_remote_data_source.dart';
import 'package:mediecom/features/account_review/data/models/company_model.dart';
import 'package:mediecom/features/account_review/domain/repositories/account_review_repository.dart';

class AccountReviewRepositoryImpl implements AccountReviewRepository {
  final AccountReviewRemoteDataSource remoteDataSource;

  AccountReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CompanyModel>> checkAccountStatus(
    String userId,
  ) async {
    try {
      final company = await remoteDataSource.checkAccountStatus(userId);
      return Right(company);
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
