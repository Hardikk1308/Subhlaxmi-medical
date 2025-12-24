import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mediecom/features/user/domain/use_cases/update_fcm_usecase.dart';

import '../../../../../core/utils/utils.dart';

part 'fcm_event.dart';
part 'fcm_state.dart';

class FcmBloc extends Bloc<FcmEvent, FcmState> {
  final UpdateFcmUsecase updateFcmUsecase;
  // final RemoveFcmUsecase removeFcmUsecase;

  FcmBloc({
    required this.updateFcmUsecase,
    //  required this.removeFcmUsecase
  }) : super(FcmInitial()) {
    on<FcmEvent>((event, emit) {});

    on<AddFcmEvent>((event, emit) async {
      emit(FcmLoading());

      final failureOrBasics = await updateFcmUsecase(
        UpdateFcmParams(userId: event.userId, fcmToken: event.fcm),
      );

      failureOrBasics.fold(
        (failure) => emit(
          FcmError(
            message: mapFailureToMessage(failure),
            statusCode: failure.statusCode,
          ),
        ),
        (booking) => emit(FcmAdded()),
      );
    });

    //     on<RemoveFcmEvent>((event, emit) async {
    //       emit(FcmLoading());

    //       final failureOrBasics = await removeFcmUsecase(event.userId);

    //       failureOrBasics.fold(
    //         (failure) => emit(
    //           FcmError(
    //             message: mapFailureToMessage(failure),
    //             statusCode: failure.statusCode,
    //           ),
    //         ),
    //         (booking) => emit(FcmRemoved()),
    //       );
    //     });
  }
}
