class ApiException implements Exception {
  final String message;
  final int statusCode;
  final bool isRetryable;

  const ApiException({
    required this.message,
    this.statusCode = 500,
    this.isRetryable = true,
  });

  @override
  String toString() => 'ApiException(status: $statusCode, message: $message)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message =
        'Network connection unavailable. Please check your connection.',
  });

  @override
  String toString() => 'NetworkException: $message';
}

class ApplicationConflictException implements Exception {
  final String message;

  const ApplicationConflictException({
    this.message = 'You have already applied for this job.',
  });

  @override
  String toString() => 'ApplicationConflictException: $message';
}
