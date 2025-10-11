import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  final int? statusCode;
  final String? details;

  const Failure(this.message, {this.statusCode, this.details});

  @override
  String toString() =>
      'Failure(message: $message, statusCode: $statusCode, details: $details)';
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({int? statusCode, String? details})
    : super(
        "Unauthorized. There is no active account for these credentials\n"
        "\n"
        "If you had an existing account, please contact",
        statusCode: statusCode,
        details: details,
      );
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({int? statusCode, String? details})
    : super("Resource not found.", statusCode: statusCode, details: details);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure({int? statusCode, String? details})
    : super("$details", statusCode: statusCode, details: details);
}

class NetworkFailure extends Failure {
  const NetworkFailure({int? statusCode, String? details})
    : super(
        "Network error. Please check your connection.",
        statusCode: statusCode,
        details: details,
      );
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({int? statusCode, String? details})
    : super(
        "Connection timed out. Try again.",
        statusCode: statusCode,
        details: details,
      );
}

class ConflictFailure extends Failure {
  const ConflictFailure({int? statusCode, String? details})
    : super(
        "Conflict occurred. Maybe the data already exists.",
        statusCode: statusCode,
        details: details,
      );
}

class ValidationFailure extends Failure {
  const ValidationFailure({int? statusCode, String? details})
    : super(
        "Validation failed. Please check your input.",
        statusCode: statusCode,
        details: details,
      );
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({int? statusCode, String? details})
    : super(
        "Too many requests. Slow down.",
        statusCode: statusCode,
        details: details,
      );
}

class ServerFailure extends Failure {
  const ServerFailure({int? statusCode, String? details})
    : super(
        "Server error. Please try again later.",
        statusCode: statusCode,
        details: details,
      );
}

class ParseFailure extends Failure {
  const ParseFailure(String message, {int? statusCode, String? details})
    : super(message, statusCode: statusCode, details: details);
}

class LocationEnabledFailure extends Failure {
  const LocationEnabledFailure()
    : super("Please enable location, and try again!");
}

class LocationPermissonFailure extends Failure {
  const LocationPermissonFailure()
    : super("Please allow location permission, and try again!");
}

Failure mapDioException(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return const TimeoutFailure();
  }

  if (e.type == DioExceptionType.connectionError) {
    return const NetworkFailure();
  }

  try {
    return BadRequestFailure(
      details:
          e.response!.data["error"] ??
          e.response!.data["detail"] ??
          e.response!.data["message"],
    );
  } catch (error) {
    print(error);
    print(e.error);
    print(e.message);
    print(e.stackTrace);
    print(e.type);
    print(e.response);
    return BadRequestFailure(details: e.response!.data.toString());
  }
}
