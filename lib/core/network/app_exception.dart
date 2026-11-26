/// Base exception for all application-level errors in DriveOS Mobile.
class AppException implements Exception {
  /// A human-readable description of the error.
  final String message;

  /// The HTTP status code associated with this error, if applicable.
  final int? statusCode;

  /// Optional raw payload or metadata returned by the failing layer.
  final dynamic details;

  /// Creates an [AppException].
  AppException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() => message;
}

/// Exception thrown when an HTTP 401 occurs or the JWT is invalid or expired.
class AuthenticationException extends AppException {
  /// Creates an [AuthenticationException].
  AuthenticationException({
    super.message = 'Session expired or unauthorized. Please sign in again.',
    super.statusCode = 401,
    super.details,
  });
}

/// Exception thrown when an HTTP 403 Forbidden occurs.
class AccessDeniedException extends AppException {
  /// Creates an [AccessDeniedException].
  AccessDeniedException({
    super.message =
        'You do not have permission to access this branch or resource.',
    super.statusCode = 403,
    super.details,
  });
}

/// Exception thrown when an HTTP 400 or 422 validation error occurs.
class ValidationException extends AppException {
  /// Creates a [ValidationException].
  ValidationException({
    required super.message,
    super.statusCode = 400,
    super.details,
  });
}

/// Exception thrown when an HTTP 404 Not Found occurs.
class NotFoundException extends AppException {
  /// Creates a [NotFoundException].
  NotFoundException({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
    super.details,
  });
}

/// Exception thrown when an HTTP 409 Conflict occurs.
class ConflictException extends AppException {
  /// Creates a [ConflictException].
  ConflictException({
    super.message =
        'The operation conflicted with the current state of the resource.',
    super.statusCode = 409,
    super.details,
  });
}

/// Exception thrown when an HTTP 500+ server error occurs.
class ServerException extends AppException {
  /// Creates a [ServerException].
  ServerException({
    super.message = 'A server error occurred. Please try again later.',
    super.statusCode = 500,
    super.details,
  });
}

/// Exception thrown when a socket, timeout, or connectivity error occurs.
class NetworkException extends AppException {
  /// Creates a [NetworkException].
  NetworkException({
    super.message =
        'Unable to connect to the server. Please check your internet connection.',
    super.statusCode,
    super.details,
  });
}
