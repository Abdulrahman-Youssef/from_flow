import 'package:dio/dio.dart';

String handleDioException(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return 'Connection timed out. Please check your internet.';
  }

  if (e.type == DioExceptionType.badResponse) {
    if (e.response?.statusCode == 401) {
      // return 'Invalid email or password.';
      return 'bad request.';
    }
    if (e.response?.statusCode == 422) { // Validation error
      try {
        // Assumes your Laravel API returns errors like: {'errors': {'email': ['...']}}
        Map<String, dynamic> errors = e.response?.data['errors'];
        return errors.values.first[0]; // Get the first error message
      } catch (_) {
        return 'Invalid data provided.';
      }
    }
    if (e.response?.statusCode == 500) {
      return 'Server error. Please try again later.';
    }
    return 'Error: ${e.response?.statusMessage}';
  }

  if (e.type == DioExceptionType.connectionError) {
    return 'No internet connection.';
  }

  return 'An unknown error occurred.';
}