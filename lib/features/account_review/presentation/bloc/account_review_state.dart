part of 'account_review_bloc.dart';

sealed class AccountReviewState extends Equatable {
  const AccountReviewState();

  @override
  List<Object?> get props => [];
}

class AccountReviewInitial extends AccountReviewState {
  const AccountReviewInitial();
}

class AccountReviewLoading extends AccountReviewState {
  const AccountReviewLoading();
}

class AccountReviewUnderReview extends AccountReviewState {
  final CompanyModel company;

  const AccountReviewUnderReview({required this.company});

  @override
  List<Object?> get props => [company];
}

class AccountReviewApproved extends AccountReviewState {
  final CompanyModel company;

  const AccountReviewApproved({required this.company});

  @override
  List<Object?> get props => [company];
}

class AccountReviewRejected extends AccountReviewState {
  final CompanyModel company;
  final String reason;

  const AccountReviewRejected({
    required this.company,
    this.reason = 'Your account has been rejected. Please contact support.',
  });

  @override
  List<Object?> get props => [company, reason];
}

class AccountReviewError extends AccountReviewState {
  final String message;

  const AccountReviewError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AccountReviewPolling extends AccountReviewState {
  final CompanyModel company;
  final int checkCount;

  const AccountReviewPolling({
    required this.company,
    this.checkCount = 0,
  });

  @override
  List<Object?> get props => [company, checkCount];
}
