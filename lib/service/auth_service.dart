import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Singleton pattern: One instance for the whole app
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token'; // Key for secure storage

  // In-memory cache for the token to avoid disk reads
  String? _cachedToken;

  /// Saves the token to both secure storage and the in-memory cache.
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      _cachedToken = token;
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  /// Gets the token.
  /// First, checks the in-memory cache.
  /// If not found, attempts to read from secure storage.
  Future<String?> getToken() async {
    // Return from cache if available
    if (_cachedToken != null) {
      return _cachedToken;
    }

    // If not in cache, try to read from storage
    try {
      _cachedToken = await _storage.read(key: _tokenKey);
      return _cachedToken;
    } catch (e) {
      print('Error reading token: $e');
      return null;
    }
  }

  /// Deletes the token from secure storage and clears the cache.
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      _cachedToken = null;
    } catch (e) {
      print('Error deleting token: $e');
    }
  }
}