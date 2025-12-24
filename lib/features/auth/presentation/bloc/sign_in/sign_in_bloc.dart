import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/auth/domain/use_cases/login_usecase.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final LoginUseCase loginUseCase;

  SignInBloc({required this.loginUseCase}) : super(SignInInitial()) {
    on<SignInEvent>((event, emit) {});
    on<MobileSignInEvent>((event, emit) async {
      emit(SignInLoading());

      final failureOrBasics = await loginUseCase(event.mobile);

      failureOrBasics.fold(
        (failure) => emit(
          SignInError(
            message: mapFailureToMessage(failure),
            statusCode: failure.statusCode,
          ),
        ),
        (user) => emit(SignInSuccess(user: user)),
      );
    });
  }
}
