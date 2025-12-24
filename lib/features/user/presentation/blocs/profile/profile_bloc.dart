import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';
import 'package:mediecom/features/user/domain/use_cases/fetch_user_details_usecase.dart';
import 'package:mediecom/features/user/domain/use_cases/update_photo_usecase.dart';
import 'package:mediecom/features/user/domain/use_cases/update_user_details_usecase.dart';
import 'package:mediecom/features/user/domain/use_cases/upload_prescription_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FetchUserDetailsUsecase _fetchUserDetailsUsecase;
  final UpdateUserDetailsUsecase updateUserDetailsUsecase;
  final UploadPhotoUseCase uploadPhotoUseCase;
  final UploadPrescriptionUsecase uploadPrescriptionUsecase;
  ProfileBloc(
    this._fetchUserDetailsUsecase,
    this.updateUserDetailsUsecase,
    this.uploadPhotoUseCase,
    this.uploadPrescriptionUsecase,
  ) : super(ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateAccount);
    on<UploadPrescriptionEvent>(_onUploadPrescription);
    // on<UpdateImageEvent>(_onUpdateImage);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final failureOrSuccess = await _fetchUserDetailsUsecase(event.userId);
    log(failureOrSuccess.toString());

    failureOrSuccess.fold(
      (failure) => emit(
        ProfileError(
          message: mapFailureToMessage(failure),
          statusCode: failure.statusCode,
        ),
      ),
      (user) => emit(ProfileLoaded(user: user)),
    );
  }

  Future<void> _onUploadPrescription(
    UploadPrescriptionEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final failureOrSuccess = await uploadPrescriptionUsecase(
      UploadPrescription(file: event.file),
    );
    log(failureOrSuccess.toString());

    failureOrSuccess.fold(
      (failure) => emit(
        ProfileError(
          message: mapFailureToMessage(failure),
          statusCode: failure.statusCode,
        ),
      ),
      (user) => emit(PrescriptionSuccess(prescriptionId: user)),
    );
  }

  // Future<void> _onUpdateAccount(
  //   UpdateProfileEvent event,
  //   Emitter<ProfileState> emit,
  // ) async {
  //   emit(ProfileLoading());
  //   final failureOrSuccess = await updateUserDetailsUsecase(
  //     UpdateUserDetailsParams(user: event.params),
  //   );

  //   failureOrSuccess.fold(
  //     (failure) => emit(
  //       ProfileError(
  //         message: mapFailureToMessage(failure),
  //         statusCode: failure.statusCode,
  //       ),
  //     ),
  //     (user) => emit(ProfileUpdated(user: user)),
  //   );
  // }

  Future<void> _onUpdateAccount(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    String? newImageUrl;

    // STEP 1 — Check if user selected a new photo
    if (event.file != null && event.file!.path.isNotEmpty) {
      final photoResult = await uploadPhotoUseCase(
        UploadPhotoParams(file: event.file!),
      );

      // Handle upload error
      final uploadResponse = photoResult.fold(
        (failure) {
          emit(
            ProfileError(
              message: mapFailureToMessage(failure),
              statusCode: failure.statusCode,
            ),
          );
          return null;
        },
        (url) => url, // url returned by API
      );

      final imageUrl = uploadResponse!.m2Chk20;

      if (imageUrl == null) return; // stop if photo upload failed
      newImageUrl = imageUrl;
    }

    // // STEP 2 — Add image URL to user params if changed
    // final updatedUser = event.params.copyWith(
    //   m2Chk20: newImageUrl ?? event.params.m2Chk20,
    // );

    // STEP 3 — Update profile details
    final failureOrSuccess = await updateUserDetailsUsecase(
      UpdateUserDetailsParams(user: event.params),
    );

    failureOrSuccess.fold(
      (failure) => emit(
        ProfileError(
          message: mapFailureToMessage(failure),
          statusCode: failure.statusCode,
        ),
      ),
      (user) => emit(ProfileUpdated(user: user)),
    );
  }
}
