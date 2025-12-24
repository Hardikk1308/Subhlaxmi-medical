import 'package:mediecom/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:mediecom/features/user/domain/repositories/user_repository.dart';
import 'package:mediecom/injection_container.dart';

void initNotification() {
  // Bloc
  sl.registerFactory(() => NotificationBloc(repository: sl<UserRepository>()));
}
