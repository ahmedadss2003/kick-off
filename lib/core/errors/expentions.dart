import 'package:dio/dio.dart';

import 'error_model.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!CacheExeption
class CacheExeption implements Exception {
  final String errorMessage;
  CacheExeption({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(ErrorModel(
          errorMessage: e.response?.data?['message'] ?? 'Connection error'));
    case DioExceptionType.badCertificate:
      throw BadCertificateException(ErrorModel(
          errorMessage: e.response?.data?['message'] ?? 'Bad certificate'));
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(ErrorModel(
          errorMessage: e.response?.data?['message'] ?? 'Connection timeout'));

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(ErrorModel(
          errorMessage: e.response?.data?['message'] ?? 'Receive timeout'));

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(ErrorModel(
          errorMessage: e.response?.data?['message'] ?? 'Send timeout'));

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request
          throw BadResponseException(ErrorModel(
              errorMessage: e.response?.data?['message'] ?? 'Bad request'));

        case 401: //unauthorized
          throw UnauthorizedException(ErrorModel(
              errorMessage: e.response?.data?['message'] ?? 'Unauthorized'));

        case 403: //forbidden
          throw ForbiddenException(ErrorModel(
              errorMessage: e.response?.data?['message'] ?? 'Forbidden'));

        case 404: //not found
          throw NotFoundException(ErrorModel(
              errorMessage: e.response?.data?['message'] ?? 'Not found'));

        case 409: //conflict
          throw CofficientException(ErrorModel(
              errorMessage: e.response?.data?['message'] ?? 'Conflict'));

        case 422: // Unprocessable Entity (Laravel validation errors)
          final data = e.response!.data;
          // Extract first validation message if available
          String message = 'Validation error';
          if (data is Map) {
            if (data['errors'] is Map) {
              final errors = data['errors'] as Map;
              if (errors.isNotEmpty) {
                final firstList = errors.values.first;
                if (firstList is List && firstList.isNotEmpty) {
                  message = firstList.first.toString();
                }
              }
            } else if (data['message'] != null) {
              message = data['message'].toString();
            }
          }
          throw BadResponseException(ErrorModel(errorMessage: message));

        case 504: // Gateway timeout
          throw BadResponseException(
            ErrorModel(errorMessage: e.response?.data ?? 'Gateway timeout'),
          );

        default:
          throw BadResponseException(
            ErrorModel(errorMessage: 'Server error: ${e.response?.statusCode}'),
          );
      }

    case DioExceptionType.cancel:
      throw CancelException(
          ErrorModel(errorMessage: e.toString()),
      );

    case DioExceptionType.unknown:
      throw UnknownException(
        ErrorModel(errorMessage: e.toString()),
      );
  }
}
