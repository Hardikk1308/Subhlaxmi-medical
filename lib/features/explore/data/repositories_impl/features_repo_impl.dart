import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/explore/data/data_sources/feature_remote_data_source.dart';
import 'package:mediecom/features/explore/domain/entities/featured_entity..dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';
import 'package:mediecom/features/explore/domain/repositories/features_repository.dart';

class FeaturesRepoImpl implements FeaturesRepository {
  final FeatureRemoteDataSource remoteDataSource;

  FeaturesRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FeaturesEntity>>> getFeatured() async {
    try {
      final features = await remoteDataSource.getFeatured();
      return Right(features);
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
  Future<Either<Failure, List<ProductEntity>>> search(String query) async {
    try {
      final products = await remoteDataSource.search(query);
      return Right(products);
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
