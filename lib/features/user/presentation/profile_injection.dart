import 'package:get_it/get_it.dart';
import 'package:mediecom/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:mediecom/features/user/data/repositories_impl/user_repo_impl.dart';
import 'package:mediecom/features/user/domain/repositories/user_repository.dart';
import 'package:mediecom/features/user/domain/use_cases/fetch_user_details_usecase.dart';
import 'package:mediecom/features/user/domain/use_cases/update_fcm_usecase.dart';
import 'package:mediecom/features/user/domain/use_cases/update_photo_usecase.dart';
import 'package:mediecom/features/user/domain/use_cases/update_user_details_usecase.dart';
import 'package:mediecom/features/user/domain/use_cases/upload_prescription_usecase.dart';
import 'package:mediecom/features/user/presentation/blocs/fcm/fcm_bloc.dart';
import 'package:mediecom/features/user/presentation/blocs/profile/profile_bloc.dart';
import 'package:mediecom/injection_container.dart';

void initProfile() {
  /// Profile Use Cases Injection

  sl.registerLazySingleton<FetchUserDetailsUsecase>(
    () => FetchUserDetailsUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<UpdateUserDetailsUsecase>(
    () => UpdateUserDetailsUsecase(repository: sl.call()),
  );

  sl.registerLazySingleton<UploadPhotoUseCase>(
    () => UploadPhotoUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<UploadPrescriptionUsecase>(
    () => UploadPrescriptionUsecase(repository: sl.call()),
  );

  // sl.registerLazySingleton<NotificationUseCase>(
  //   () => NotificationUseCase(repository: sl.call()),
  // );

  // sl.registerLazySingleton<ReadNotificationUseCase>(
  //   () => ReadNotificationUseCase(repository: sl.call()),
  // );

  sl.registerLazySingleton<UpdateFcmUsecase>(
    () => UpdateFcmUsecase(repository: sl.call()),
  );

  // sl.registerLazySingleton<RemoveFcmUsecase>(
  //   () => RemoveFcmUsecase(repository: sl.call()),
  // );

  /// User Repository Injection
  sl.registerLazySingleton<UserRepository>(
    () => UserRepoImpl(remoteDataSource: sl.call()),
  );

  /// Auth Data sources Injection
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl.call()),
  );

  /// Auth  Bloc Injection
  sl.registerFactory(() => ProfileBloc(sl(), sl(), sl(), sl()));

  // sl.registerFactory(() => NotificationsListBloc(notificationUseCase: sl()));

  // sl.registerFactory(
  //   () => ReadNotificationsBloc(readNotificationUseCase: sl()),
  // );

  sl.registerFactory(() => FcmBloc(updateFcmUsecase: sl()));
}
