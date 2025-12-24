import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/account_review/data/models/company_model.dart';
import 'package:mediecom/features/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  VerifyOtpBloc({required this.verifyOtpUseCase}) : super(VerifyOtpInitial()) {
    on<VerifyOtpEvent>((event, emit) {});
    on<MobileVerifyOtpEvent>((event, emit) async {
      emit(VerifyOtpLoading());

      final failureOrBasics = await verifyOtpUseCase(
        VerifyOtpParams(otp: event.otp, userId: event.userId),
      );

      failureOrBasics.fold(
        (failure) => emit(
          VerifyOtpError(
            message: mapFailureToMessage(failure),
            statusCode: failure.statusCode,
          ),
        ),
        (user) => emit(VerifyOtpSuccess(user: user)),
      );
    });
  }
}
