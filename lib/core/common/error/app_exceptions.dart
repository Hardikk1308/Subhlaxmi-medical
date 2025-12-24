// lib/core/error/app_exceptions.dart
class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  final int statusCode;

  NetworkException({required this.message, required this.statusCode});
}

class LocalDatabaseException implements Exception {
  final String message;

  LocalDatabaseException({required this.message});
}

/// Firebase Exceptions

class FirebasePermissionDeniedException implements Exception {
  final String message;
  FirebasePermissionDeniedException({required this.message});
}

class FirebaseDocumentNotFoundException implements Exception {
  final String message;
  FirebaseDocumentNotFoundException({required this.message});
}

class FirebaseGeneralException implements Exception {
  final String message;
  FirebaseGeneralException({required this.message});
}