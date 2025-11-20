import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
// import 'package:get/get_connect/http/src/response/response.dart' hide Response; // Not needed
import '../service/auth_service.dart';

class ApiRepository {
  // This is fine. GetX will find the service from your AppBinding.
  final AuthService _authService = Get.find<AuthService>();

  // 1. The Base URL for your API
  static const String _baseUrl = "https://api-ibn-sina.abdulrahman.lt/api";

  // 2. The Singleton Pattern
  ApiRepository._internal() {
    _setupDio();
  }
  static final ApiRepository _instance = ApiRepository._internal();
  factory ApiRepository() => _instance;

  // 3. The Dio instance
  final Dio _dio = Dio();

  // 4. A private variable to hold the token
  // String? _token = await _authService.getToken(); // <-- FIX: DELETE THIS LINE

  // 5. Public method to update the token (your Auth code will call this)
  // void updateAuthToken(String? token) { // <-- FIX: DELETE THIS (not needed)
  //   _token = token;
  // }

  // 6. The setup method for Dio
  void _setupDio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 10);
    _dio.options.receiveTimeout = Duration(seconds: 10);
    _dio.options.headers['Accept'] = 'application/json';

    // 7. Add the Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        // <-- FIX: Make this function 'async'
        onRequest: (options, handler) async {

          // <-- FIX: Get the token fresh *inside* the interceptor
          String? token = await _authService.getToken();

          // This function runs BEFORE every request is sent
          if (token != null) { // <-- FIX: Use the 'token' variable
            // If we have a token, add the Authorization header
            options.headers['Authorization'] = 'Bearer $token';
          }
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