import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mediecom/features/orders/data/data_sources/order_remote_data_source.dart';
import 'package:mediecom/features/orders/data/repositories_impl/orders_repo_impl.dart';
import 'package:mediecom/features/orders/domain/repositories/orders_repository.dart';
import 'package:mediecom/features/orders/domain/use_cases/fetch_order_details_usecase.dart';
import 'package:mediecom/features/orders/domain/use_cases/fetch_order_history_usecase.dart';
import 'package:mediecom/features/orders/domain/use_cases/fetch_order_list_usecase.dart';
import 'package:mediecom/features/orders/domain/use_cases/insert_order_usecase.dart';
import 'package:mediecom/features/orders/domain/use_cases/update_order_status_usecase.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:mediecom/injection_container.dart';

Future<void> initOrders() async {
  // BLoC
  sl.registerFactory(
    () => OrdersBloc(
      fetchOrderList: sl(),
      fetchOrderDetails: sl(),
      fetchOrderHistory: sl(),
      updateOrderStatus: sl(),
      insertOrder: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchOrderListUseCase(sl()));
  sl.registerLazySingleton(() => FetchOrderDetailsUseCase(sl()));
  sl.registerLazySingleton(() => FetchOrderHistoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));
  sl.registerLazySingleton(() => InsertOrderUseCase(sl()));

  // Repository
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(client: sl()),
  );
}
