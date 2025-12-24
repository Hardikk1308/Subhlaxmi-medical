import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/features/notification/presentation/bloc/notification_event.dart';
import 'package:mediecom/features/notification/presentation/bloc/notification_state.dart';
import 'package:mediecom/features/user/domain/repositories/user_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final UserRepository repository;

  NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    final result = await repository.getNotifications(event.userId);

    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notifications) => emit(NotificationLoaded(notifications: notifications)),
    );
  }
}
