import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_flow/models/user_model.dart';
import 'shared_pref_service.dart'; // Import your SharedPrefService

class AuthService {
  // Singleton pattern
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final _secureStorage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  // In-memory cache
  String? _cachedToken;
  UserModel? _cachedUser;

  final _sharedPref = SharedPrefService();

  /// Save token and user together
  Future<void> saveAuth({required String token, required UserModel user}) async {
    _cachedToken = token;
    _cachedUser = user;

    // Save token securely
    await _secureStorage.write(key: _tokenKey, value: token);

    // Save user in SharedPrefService
    await _sharedPref.saveJson(_userKey, user.toJson());
  }

  /// Get token
  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    _cachedToken = await _secureStorage.read(key: _tokenKey);
    return _cachedToken;
  }

  /// Get user
  Future<UserModel?> getUser() async {
    if (_cachedUser != null) return _cachedUser;

    final userJson = _sharedPref.getJson(_userKey);
    if (userJson != null) {
      _cachedUser = UserModel.fromJson(userJson);
      return _cachedUser;
    }

    return null;
  }

  /// Delete token and user (logout)
  Future<void> logout() async {
    _cachedToken = null;
    _cachedUser = null;

    await _secureStorage.delete(key: _tokenKey);
    await _sharedPref.remove(_userKey);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
