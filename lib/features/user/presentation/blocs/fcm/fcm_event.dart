part of 'fcm_bloc.dart';

sealed class FcmEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddFcmEvent extends FcmEvent {
  final String userId;
  final String fcm;

  AddFcmEvent({required this.userId, required this.fcm});

  @override
  List<Object?> get props => [userId, fcm];
}

class RemoveFcmEvent extends FcmEvent {
  final String userId;

  RemoveFcmEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
