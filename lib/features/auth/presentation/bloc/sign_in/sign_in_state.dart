part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final UserEntity user;

  const SignInSuccess({required this.user});

  @override
  List<Object> get props => [user];


}

class SignInError extends SignInState {
  final int statusCode;
  final String message;

  const SignInError({required this.statusCode, required this.message});

  @override
  List<Object> get props => [statusCode, message];
}
