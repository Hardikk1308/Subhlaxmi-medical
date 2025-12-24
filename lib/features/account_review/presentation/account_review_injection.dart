import 'package:mediecom/features/account_review/data/data_sources/account_review_remote_data_source.dart';
import 'package:mediecom/features/account_review/data/repositories/account_review_repository_impl.dart';
import 'package:mediecom/features/account_review/domain/repositories/account_review_repository.dart';
import 'package:mediecom/features/account_review/domain/usecases/check_account_status_usecase.dart';
import 'package:mediecom/features/account_review/presentation/bloc/account_review_bloc.dart';
import 'package:mediecom/injection_container.dart';

void initAccountReview() {
  // Data Sources
  if (!sl.isRegistered<AccountReviewRemoteDataSource>()) {
    sl.registerLazySingleton<AccountReviewRemoteDataSource>(
      () => AccountReviewRemoteDataSourceImpl(client: sl()),
    );
  }

  // Repositories
  if (!sl.isRegistered<AccountReviewRepository>()) {
    sl.registerLazySingleton<AccountReviewRepository>(
      () => AccountReviewRepositoryImpl(remoteDataSource: sl()),
    );
  }

  // Use Cases
  if (!sl.isRegistered<CheckAccountStatusUseCase>()) {
    sl.registerLazySingleton<CheckAccountStatusUseCase>(
      () => CheckAccountStatusUseCase(repository: sl()),
    );
  }

  // BLoCs
  if (!sl.isRegistered<AccountReviewBloc>()) {
    sl.registerLazySingleton<AccountReviewBloc>(
      () => AccountReviewBloc(checkAccountStatusUseCase: sl()),
    );
  }
}
