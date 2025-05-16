/// Exception for network related errors
class NetworkException implements Exception {
  /// Creates a new network exception
  const NetworkException(this.message, {this.statusCode});

  /// Error message
  final String message;

  /// HTTP status code, if applicable
  final int? statusCode;

  @override
  String toString() =>
      'NetworkException: $message${statusCode != null ? ' (Status code: $statusCode)' : ''}';
}
