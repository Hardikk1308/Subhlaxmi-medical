part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MobileSignInEvent extends SignInEvent {
  final String mobile;

  MobileSignInEvent({ required this.mobile});

  @override
  List<Object?> get props => [mobile];
}

