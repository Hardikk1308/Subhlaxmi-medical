import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;

  const Failure({required this.message, required this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, required super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, required super.statusCode});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, required super.statusCode});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, required super.statusCode});
}

/// Firebase Failures

class FirebasePermissionFailure extends Failure {
  const FirebasePermissionFailure({
    required super.message,
    required super.statusCode,
  });
}

class FirebaseDocumentNotFoundFailure extends Failure {
  const FirebaseDocumentNotFoundFailure({
    required super.message,
    required super.statusCode,
  });
}

class FirebaseGeneralFailure extends Failure {
  const FirebaseGeneralFailure({
    required super.message,
    required super.statusCode,
  });
}
