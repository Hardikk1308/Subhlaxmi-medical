part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  final String userId;

  const GetProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileEvent extends ProfileEvent {
  final File? file;
  final UserModel params;

  const UpdateProfileEvent({required this.params, required this.file});

  @override
  List<Object?> get props => [params];
}

class UploadPrescriptionEvent extends ProfileEvent {
  final List<File> file;

  const UploadPrescriptionEvent({required this.file});

  @override
  List<Object?> get props => [file];
}
