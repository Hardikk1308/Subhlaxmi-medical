part of 'fcm_bloc.dart';

sealed class FcmState extends Equatable {
  const FcmState();

  @override
  List<Object> get props => [];
}

class FcmInitial extends FcmState {}

class FcmLoading extends FcmState {}

class FcmAdded extends FcmState {
  @override
  List<Object> get props => [];
}

class FcmRemoved extends FcmState {
  @override
  List<Object> get props => [];
}

class FcmError extends FcmState {
  final int statusCode;
  final String message;

  const FcmError({
    required this.statusCode,
    required this.message,
  });

  @override
  List<Object> get props => [statusCode, message];
}
