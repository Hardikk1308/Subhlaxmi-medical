part of 'send_otp_bloc.dart';

sealed class SendOtpState extends Equatable {
  const SendOtpState();

  @override
  List<Object> get props => [];
}

class SendOtpInitial extends SendOtpState {}

class SendOtpLoading extends SendOtpState {}

class SendOtpSuccess extends SendOtpState {
  final String userId;

  SendOtpSuccess({required this.userId});
}

class SendOtpError extends SendOtpState {
  final int statusCode;
  final String message;

  const SendOtpError({required this.statusCode, required this.message});

  @override
  List<Object> get props => [statusCode, message];
}
