import 'package:get_it/get_it.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:mediecom/injection_container.dart';

Future<void> initCartDependencies() async {
  // BLoC
  sl.registerFactory<CartBloc>(() => CartBloc());

  // Add repositories, data sources, and use cases here when implemented
  // Example:
  // Repositories
  // sl.registerLazySingleton<CartRepository>(
  //   () => CartRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //   ),
  // );

  // Use cases
  // sl.registerLazySingleton(() => SaveCartUseCase(sl()));
  // sl.registerLazySingleton(() => GetCartUseCase(sl()));
  // sl.registerLazySingleton(() => ClearCartUseCase(sl()));

  // Data sources
  // sl.registerLazySingleton<CartRemoteDataSource>(
  //   () => CartRemoteDataSourceImpl(client: sl()),
  // );
  // sl.registerLazySingleton<CartLocalDataSource>(
  //   () => CartLocalDataSourceImpl(sharedPreferences: sl()),
  // );
}
