import 'package:get_it/get_it.dart';
import 'package:mediecom/features/explore/data/data_sources/feature_remote_data_source.dart';
import 'package:mediecom/features/explore/data/data_sources/product_remote_data_source.dart';
import 'package:mediecom/features/explore/data/repositories_impl/features_repo_impl.dart';
import 'package:mediecom/features/explore/data/repositories_impl/product_repository_impl.dart';
import 'package:mediecom/features/explore/domain/repositories/features_repository.dart';
import 'package:mediecom/features/explore/domain/repositories/product_repository.dart';
import 'package:mediecom/features/explore/domain/usecases/fetch_features_usecase.dart';
import 'package:mediecom/features/explore/domain/usecases/get_products_usecase.dart';
import 'package:mediecom/features/explore/domain/usecases/get_product_details_usecase.dart';
import 'package:mediecom/features/explore/domain/usecases/search_usecase.dart';
import 'package:mediecom/features/explore/presentation/bloc/features/features_bloc.dart';
import 'package:mediecom/features/explore/presentation/bloc/product_bloc.dart';
import 'package:mediecom/features/explore/presentation/bloc/search/search_bloc.dart';
import 'package:mediecom/injection_container.dart';

void initExplore() {
  // Use cases

  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
  sl.registerLazySingleton(() => FetchFeaturesUsecase(repository: sl()));
  sl.registerLazySingleton(() => SearchUsecase(repository: sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  // Repository
  sl.registerLazySingleton<FeaturesRepository>(
    () => FeaturesRepoImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );
  // Data sources
  sl.registerLazySingleton<FeatureRemoteDataSource>(
    () => FeatureRemoteDataSourceImpl(apihelpers: sl()),
  );

  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getProductsUseCase: sl(),
      getProductDetailsUseCase: sl(),
    ),
  );
  sl.registerFactory(() => FeaturesBloc(sl()));
  sl.registerFactory(() => SearchBloc(sl()));
}
