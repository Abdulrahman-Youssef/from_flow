import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/response/response.dart' hide Response;

class ApiService {
  // 1. The Base URL for your API
  static const String _baseUrl = "https://api-ibn-sina.abdulrahman.lt/api";

  // 2. The Singleton Pattern
  ApiService._internal() {
    // Call the setup method in the private constructor
    _setupDio();
  }
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // 3. The Dio instance
  final Dio _dio = Dio();

  // 4. A private variable to hold the token
  // String? _token;

  // 5. Public method to update the token (your Auth code will call this)
  // void updateAuthToken(String? token) {
  //   _token = token;
  // }

  // 6. The setup method for Dio
  void _setupDio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = Duration(milliseconds: 5000);
    _dio.options.receiveTimeout = Duration(milliseconds: 3000);
    _dio.options.headers['Accept'] = 'application/json';

    // 7. Add the Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // This function runs BEFORE every request is sent
          // if (_token != null) {
          //   // If we have a token, add the Authorization header
          //   options.headers['Authorization'] = 'Bearer $_token';
          // }
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options); // Continue
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}]');
          return handler.next(response); // Continue
        },
        onError: (DioException e, handler) {
          print('ERROR[${e.response?.statusCode}] => ${e.message}');
          return handler.next(e); // Propagate the error
        },
      ),
    );
  }

  // 8. Your new, simplified methods
  // We don't need `getAuth` anymore! The interceptor handles it.

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    // The interceptor will add the token if it exists
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) {
    // The interceptor will add the token if it exists
    // Dio automatically handles converting 'data' to JSON
    return _dio.post(path, data: data);
  }

  // You can easily add other methods too
  Future<Response> put(String path, {Map<String, dynamic>? data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}