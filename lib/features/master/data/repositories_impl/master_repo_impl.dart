import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_exceptions.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/master/data/data_sources/master_remote_data_source.dart';
import 'package:mediecom/features/master/domain/entities/category_entity.dart';
import 'package:mediecom/features/master/domain/entities/slider_entity.dart';
import 'package:mediecom/features/master/domain/entities/sub_category_entity.dart';
import 'package:mediecom/features/master/domain/repositories/master_repository.dart';

class MasterRepositoryImpl implements MasterRepository {
  final MasterRemoteDataSource remoteDataSource;

  MasterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SliderEntity>>> getBanners() async {
    try {
      final user = await remoteDataSource.getBanners();
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
  Future<Either<Failure, List<CategoryEntity>>> getCategory() async {
    try {
      final user = await remoteDataSource.getCategory();
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

  // @override
  // Future<Either<Failure, List<NestedCategoryEntity>>> getNestedSubCategories() async{
  //   try {
  //     final user = await remoteDataSource.getNestedSubCategories();
  //     return Right(user);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
  //   } on NetworkException catch (e) {
  //     return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
  //   } catch (e) {
  //     return const Left(UnexpectedFailure(
  //         message: 'Unexpected error occurred', statusCode: 500));
  //   }
  // }

  @override
  Future<Either<Failure, List<SubcategoryEntity>>> getSubCategory(
    String catId,
  ) async {
    try {
      final user = await remoteDataSource.getSubCategory(catId);
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
