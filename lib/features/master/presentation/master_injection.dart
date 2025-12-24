import 'package:get_it/get_it.dart';
import 'package:mediecom/features/master/data/data_sources/master_remote_data_source.dart';
import 'package:mediecom/features/master/data/repositories_impl/master_repo_impl.dart';
import 'package:mediecom/features/master/domain/repositories/master_repository.dart';
import 'package:mediecom/features/master/domain/use_cases/get_banners_usecase.dart';
import 'package:mediecom/features/master/domain/use_cases/get_category_use_case.dart';
import 'package:mediecom/features/master/domain/use_cases/get_subcategory_usecase.dart';
import 'package:mediecom/features/master/presentation/blocs/banner/banner_bloc.dart';
import 'package:mediecom/features/master/presentation/blocs/category/category_bloc.dart';
import 'package:mediecom/features/master/presentation/blocs/sub_category/sub_category_bloc.dart';
import 'package:mediecom/injection_container.dart';

void initMaster() {
  /// Master Use Cases Injection

  sl.registerLazySingleton<GetCategoryUseCase>(
    () => GetCategoryUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetSubcategoryUsecase>(
    () => GetSubcategoryUsecase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetBannerUseCase>(
    () => GetBannerUseCase(repository: sl.call()),
  );

  // sl.registerLazySingleton<GetNestedSubCategoryUseCase>(
  //   () => GetNestedSubCategoryUseCase(repository: sl.call()),
  // );

  /// Master Repository Injection
  sl.registerLazySingleton<MasterRepository>(
    () => MasterRepositoryImpl(remoteDataSource: sl.call()),
  );

  /// Master Data sources Injection
  sl.registerLazySingleton<MasterRemoteDataSource>(
    () => MasterRemoteDataSourceImpl(client: sl.call()),
  );

  /// Master  Bloc Injection
  sl.registerFactory(() => CategoryBloc(getCategoryUseCase: sl()));
  sl.registerFactory(() => SubCategoryBloc(getSubCategoryUseCase: sl()));
  // sl.registerFactory(
  // () => NestedSubCategoryBloc(getNestedSubCategoryUseCase: sl()),
  // );
  sl.registerFactory(() => BannerBloc(getBannerUseCase: sl()));
}
