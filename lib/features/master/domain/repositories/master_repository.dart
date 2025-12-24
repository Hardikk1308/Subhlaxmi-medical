import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/master/domain/entities/category_entity.dart';
import 'package:mediecom/features/master/domain/entities/slider_entity.dart';
import 'package:mediecom/features/master/domain/entities/sub_category_entity.dart';

abstract class MasterRepository {
  Future<Either<Failure, List<SliderEntity>>> getBanners();

  Future<Either<Failure, List<CategoryEntity>>> getCategory();

  // Future<Either<Failure, List<NestedCategoryEntity>>>
  // getNestedSubCategories();

  Future<Either<Failure, List<SubcategoryEntity>>> getSubCategory(String catId);
}
