part of 'account_review_bloc.dart';

sealed class AccountReviewEvent extends Equatable {
  const AccountReviewEvent();

  @override
  List<Object?> get props => [];
}

class CheckAccountStatusEvent extends AccountReviewEvent {
  final String userId;

  const CheckAccountStatusEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class StartPollingEvent extends AccountReviewEvent {
  final String userId;
  final Duration interval;

  const StartPollingEvent({
    required this.userId,
    this.interval = const Duration(seconds: 5),
  });

  @override
  List<Object?> get props => [userId, interval];
}

class StopPollingEvent extends AccountReviewEvent {
  const StopPollingEvent();
}
