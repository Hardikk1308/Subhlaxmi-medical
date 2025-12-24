import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/auth/domain/use_cases/send_otp_usecase.dart';

part 'send_otp_event.dart';
part 'send_otp_state.dart';

class SendOtpBloc extends Bloc<SendOtpEvent, SendOtpState> {
  final SendOtpUseCase sendOtpUseCase;

  SendOtpBloc({required this.sendOtpUseCase}) : super(SendOtpInitial()) {
    on<SendOtpEvent>((event, emit) {});
    on<MobileSendOtpEvent>((event, emit) async {
      emit(SendOtpLoading());

      final failureOrBasics = await sendOtpUseCase(event.userId);

      failureOrBasics.fold(
        (failure) => emit(
          SendOtpError(
            message: mapFailureToMessage(failure),
            statusCode: failure.statusCode,
          ),
        ),
        (userId) => emit(SendOtpSuccess(userId: userId)),
      );
    });
  }
}
