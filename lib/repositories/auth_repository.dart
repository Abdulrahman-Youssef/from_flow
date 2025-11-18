import 'package:dio/dio.dart';
import 'package:form_flow/core/data/constant/services_routes.dart';
import 'package:form_flow/models/user_model.dart';
import 'package:form_flow/service/auth_service.dart';
import 'package:form_flow/repositories/api_repository.dart';

import '../core/utils/handle_dio_errors.dart';


class AuthRepository   {
  // Get the singleton instances of the services
  final ApiRepository _apiService = ApiRepository();
  final AuthService _authService = AuthService();

  /// Attempts to log the user in.
  /// On success, it saves the token and returns the response data.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await _apiService.post(ServicesRoutes.login, data: body);

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;

        // Find the token in the response (adjust 'token' key if yours is different)
        if (responseData.containsKey('access_token') && responseData.containsKey('user')) {
          await _authService.saveAuth( token: responseData['access_token'], user: UserModel.fromJson(responseData['user']),);
        }

        return responseData; // e.g., {'token': '...', 'user': {...}}
      } else {
        throw 'Failed to log in. Invalid server response.';
      }
    } on DioException catch (e) {
      throw handleDioException(e); // Standardized error
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }


  /// Fetches the currently authenticated user's data.
  /// This is the perfect way to validate an existing token.
  Future<Map<String, dynamic>> getUser() async {
    try {
      // 1. Make a GET request to a protected route.
      // The ApiService interceptor will automatically add the token.
      // Make sure '/user' matches a real endpoint in your 'routes/api.php'
      final response = await _apiService.get(ServicesRoutes.user);

      if (response.statusCode == 200 && response.data != null) {

        return response.data as Map<String, dynamic>;
      } else {
        throw 'Failed to get user. Invalid server response.';
      }
    } on DioException catch (e) {
      // If the token is expired or invalid, the server will return a 401
      // and our helper will throw a clean error.
      throw handleDioException(e);
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
      final response = await _apiService.post(ServicesRoutes.register, data: body);

      if (response.statusCode == 201 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;

        // Save the token on successful registration
        if (responseData.containsKey('access_token')) {
          await _authService.saveAuth(token: responseData['access_token'], user: responseData['user'],);
        }

        return responseData;
      } else {
        throw 'Failed to register. Invalid server response.';
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Logs the user out.
  /// Tells the server to invalidate the token AND deletes the local token.
  Future<void> logout() async {
    try {
      // 1. Tell the server to invalidate the token (interceptor adds auth)
      await _apiService.post(ServicesRoutes.logout);
    } catch (e) {
      // We don't care about errors here. If the token is already
      // expired or the server is down, we still need to log out locally.
      print('Ignoring server logout error: $e');
    }

    // 2. ALWAYS delete the local token. This is the most important part.
    await _authService.logout();
  }

  /// Standardizes error messages from Dio.

}