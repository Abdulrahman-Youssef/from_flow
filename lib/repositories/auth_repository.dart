import 'package:dio/dio.dart';
import 'package:form_flow/service/AuthenticationService.dart';
import 'package:form_flow/service/api_service.dart';


class AuthRepository {
  // Get the singleton instances of the services
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  /// Attempts to log the user in.
  /// On success, it saves the token and returns the response data.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await _apiService.post('/login', data: body);

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;

        // Find the token in the response (adjust 'token' key if yours is different)
        if (responseData.containsKey('token')) {
          await _authService.saveToken(responseData['token']);
        }

        return responseData; // e.g., {'token': '...', 'user': {...}}
      } else {
        throw 'Failed to log in. Invalid server response.';
      }
    } on DioException catch (e) {
      throw _handleDioException(e); // Standardized error
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Attempts to register a new user.
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
    };

    try {
      final response = await _apiService.post('/register', data: body);

      if (response.statusCode == 201 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;

        // Save the token on successful registration
        if (responseData.containsKey('token')) {
          await _authService.saveToken(responseData['token']);
        }

        return responseData;
      } else {
        throw 'Failed to register. Invalid server response.';
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Logs the user out.
  /// Tells the server to invalidate the token AND deletes the local token.
  Future<void> logout() async {
    try {
      // 1. Tell the server to invalidate the token (interceptor adds auth)
      await _apiService.post('/logout');
    } catch (e) {
      // We don't care about errors here. If the token is already
      // expired or the server is down, we still need to log out locally.
      print('Ignoring server logout error: $e');
    }

    // 2. ALWAYS delete the local token. This is the most important part.
    await _authService.deleteToken();
  }

  /// Standardizes error messages from Dio.
  String _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please check your internet.';
    }

    if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 401) {
        return 'Invalid email or password.';
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
}