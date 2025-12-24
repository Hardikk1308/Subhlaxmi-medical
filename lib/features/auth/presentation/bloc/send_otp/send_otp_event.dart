part of 'send_otp_bloc.dart';

sealed class SendOtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MobileSendOtpEvent extends SendOtpEvent {
  final String userId;

  MobileSendOtpEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}


