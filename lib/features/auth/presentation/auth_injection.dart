import 'package:get_it/get_it.dart';
import 'package:mediecom/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mediecom/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:mediecom/features/auth/domain/repositories/auth_repo.dart';
import 'package:mediecom/features/auth/domain/use_cases/login_usecase.dart';
import 'package:mediecom/features/auth/domain/use_cases/send_otp_usecase.dart';
import 'package:mediecom/features/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:mediecom/features/auth/presentation/bloc/send_otp/send_otp_bloc.dart';
import 'package:mediecom/features/auth/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:mediecom/features/auth/presentation/bloc/verify_otp/verify_otp_bloc.dart';

import '../../../injection_container.dart';

void initAuth() {
  /// Auth Use Cases
  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(repository: sl()),
    );
  }

  if (!sl.isRegistered<SendOtpUseCase>()) {
    sl.registerLazySingleton<SendOtpUseCase>(
      () => SendOtpUseCase(repository: sl()),
    );
  }

  if (!sl.isRegistered<VerifyOtpUseCase>()) {
    sl.registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(repository: sl()),
    );
  }

  /// Auth Repository
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()),
    );
  }

  /// Auth Remote Data Source
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()),
    );
  }

  /// Blocs (Factory — no need for isRegistered check because factory always creates new instances)
  sl.registerFactory(() => SignInBloc(loginUseCase: sl()));
  sl.registerFactory(() => SendOtpBloc(sendOtpUseCase: sl()));
  sl.registerFactory(() => VerifyOtpBloc(verifyOtpUseCase: sl()));
}
