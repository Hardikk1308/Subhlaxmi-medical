import 'package:equatable/equatable.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {
  final String userId;

  const FetchNotificationsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
