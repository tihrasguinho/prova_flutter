abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException(this.message, [this.stackTrace]);
}

class DatabaseException extends AppException {
  DatabaseException(super.message, [super.stackTrace]);
}

class NetworkException extends AppException {
  NetworkException(super.message, [super.stackTrace]);
}

class UnknownException extends AppException {
  UnknownException(super.message, [super.stackTrace]);
}
