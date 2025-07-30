import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio _dio;
  static const String baseUrl = 'https://fakestoreapi.com';

  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      ) {
    // Add interceptors
    _dio.interceptors.add(
      LogInterceptor(
        request: kDebugMode,
        requestHeader: kDebugMode,
        requestBody: kDebugMode,
        responseHeader: kDebugMode,
        responseBody: kDebugMode,
        error: kDebugMode,
      ),
    );
  }

  // Add auth token interceptor
  void setAuthToken(String token) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
    );
  }

  // Clear auth token interceptor
  void clearAuthToken() {
    _dio.interceptors.clear();
    // Reinitialize log interceptor only
    _dio.interceptors.add(
      LogInterceptor(
        request: kDebugMode,
        requestHeader: kDebugMode,
        requestBody: kDebugMode,
        responseHeader: kDebugMode,
        responseBody: kDebugMode,
        error: kDebugMode,
      ),
    );
  }

  // Generic GET request
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) converter,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return converter(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) converter,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return converter(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) converter,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return converter(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<T> delete<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) converter,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return converter(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Connection timed out. Please try again.');

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return RequestCancelledException('Request was cancelled');

      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');

      default:
        return ApiException('An unexpected error occurred: ${error.message}');
    }
  }

  Exception _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (statusCode) {
      case 400:
        return BadRequestException('Invalid request: ${data ?? 'Bad Request'}');
      case 401:
        return UnauthorizedException(
          'Unauthorized: ${data ?? 'Authentication required'}',
        );
      case 403:
        return ForbiddenException('Access denied: ${data ?? 'Forbidden'}');
      case 404:
        return NotFoundException('Not found: ${data ?? 'Resource not found'}');
      case 409:
        return ConflictException('Conflict: ${data ?? 'Resource conflict'}');
      case 422:
        return ValidationException(
          'Validation error: ${data ?? 'Invalid data'}',
        );
      case 500:
        return ServerException(
          'Server error: ${data ?? 'Internal server error'}',
        );
      default:
        return ApiException(
          'API error ${statusCode ?? 'unknown'}: ${data ?? error.message}',
        );
    }
  }
}

// Custom exceptions
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class TimeoutException extends ApiException {
  TimeoutException(super.message);
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class BadRequestException extends ApiException {
  BadRequestException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class ConflictException extends ApiException {
  ConflictException(super.message);
}

class ValidationException extends ApiException {
  ValidationException(super.message);
}

class ServerException extends ApiException {
  ServerException(super.message);
}

class RequestCancelledException extends ApiException {
  RequestCancelledException(super.message);
}
