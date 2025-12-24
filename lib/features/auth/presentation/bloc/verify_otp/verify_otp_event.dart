part of 'verify_otp_bloc.dart';

sealed class VerifyOtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MobileVerifyOtpEvent extends VerifyOtpEvent {
  final String userId;
  final String otp;

  MobileVerifyOtpEvent(
      {required this.otp, required this.userId});

  @override
  List<Object?> get props => [userId, otp];
}

class EmailVerifyOtpEvent extends VerifyOtpEvent {
  final String email;
  final String otp;

  EmailVerifyOtpEvent({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}
